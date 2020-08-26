//
//  ParallaxKit.swift
//  Parallax
//
//  Created by marco on 2020/8/23.
//  Copyright © 2020 flywire. All rights reserved.
//

import UIKit

///一个动画帧组内的可动画小部件
struct AnimateWidget {
    ///动画发生的view
    var view:UIView
    
    ///关联的动画起始和结束值
    var translateY:[CGFloat]?
    var translateX:[CGFloat]?
    var opacity:[CGFloat]?
    var scale:[CGFloat]?
    var rotate:[CGFloat]?

    subscript(member:String) -> [CGFloat]?{
        switch member{
        case "translateY":
            return translateY
        case "translateX":
            return translateX
        case "opacity":
            return opacity
        case "scale":
            return scale
        case "rotate":
            return rotate
        default:
            return nil
        }
    }
}

///动画帧组，一个动画帧组包括一个发生动画的View和上面可动画的部件。
struct AnimateFrame {
    var wrapper:UIView
    var duration:CGFloat
    var animations:[AnimateWidget]
}

enum ParallaxDirection:Int{
    case down, up, left, right
}

class ParallaxManager:NSObject {
    
    //目前支持的属性
    let PROPERTIES =  ["translateX", "translateY", "opacity", "rotate", "scale"]

    private var wrappers = [UIView]()
    private var currentWrapper: UIView?

    private var bodyHeight:CGFloat = 0
    private var windowHeight:CGFloat = 0
    private var windowWidth:CGFloat = 0
    private var prevKeyframesDurations:CGFloat = 0
    private var scrollTop:CGFloat = 0
    private var relativeScrollTop:CGFloat = 0
    private var currentKeyframe = 0
    
    //原始动画数组
    private var keyframes = [[String:Any]]()
    
    ///考虑在原始动画中使用字符串替代具体的视图，需要映射一下
//    var namedViews = [String:UIView]()
    
    ///经过值变换后的动画数组
    private var animateFrames = [AnimateFrame]()
    
    private(set) var scrollView:UIScrollView
   
    ///可用来作为视差动画的背景，也是整个滚动动画中用户可见的窗口区域，所有page都会放在上面
    private var backView:UIImageView
    
    // TODO: 暂不支持方向
    init(with scrollView:UIScrollView, direction:ParallaxDirection){
        self.scrollView = scrollView
        self.backView = UIImageView.init(frame: scrollView.bounds)
        super.init()
        scrollView.addSubview(backView)
    }
    
    //如果动画字典里的View使用字符串的话，需要做映射。
//    func register(view:UIView,for key:String){
//        namedViews[key] = view
//    }
    
//    func configureAnimations(animations:[[String:Any]]){
//        keyframes = animations
//        setupValues()
//        generateAnimations();
//    }
    
    // MARK: 对外接口
    var backgroundImage:UIImage? {
        get{
            return backView.image
        }
        set{
            backView.image = newValue
        }
    }

    ///
    func addKeyFrameAnimation(animation:[String:Any]) {
        keyframes.append(animation)
    }
    
    func generateKeyFrameAnimations() {
        setupValues()
        generateAnimations()
    }
    
    func clearAllFrames() {
        keyframes.removeAll()
        animateFrames.removeAll()
        
        wrappers.forEach { (view) in
            view.removeFromSuperview()
        }
        wrappers.removeAll()
        
        bodyHeight = 0
        windowHeight = 0
        windowWidth = 0
        prevKeyframesDurations = 0
        scrollTop = 0
        relativeScrollTop = 0
        currentKeyframe = 0
        currentWrapper = nil
    }

    // MARK: 内部实现
    // scrollView可能是自动布局的，所以当前可能获取不到scrollView最终的尺寸。必须确保在scrollView layout之后执行，才能获得正确的值
    private func setupValues() {
        backView.frame = scrollView.bounds
        scrollTop = scrollView.contentOffset.y
        windowHeight = scrollView.bounds.size.height
        windowWidth = scrollView.bounds.size.width
    }
    
    /*将原始动画帧转为值处理后的动画帧
     将百分比转换成具体的坐标值，并且将单个的值转换成包含起始值的数组
     */
    private func generateAnimations() {
        for keyframe in keyframes {
            let duration = convertPercentToPx(value: keyframe["duration"] as! String, axis: "y")
            
            bodyHeight += duration
                 
            //不含wrapper，则只增加滚动范围
            if !keyframe.keys.contains("wrapper") {
                continue
            }
            
            let view = keyframe["wrapper"] as! UIView
        
            if !wrappers.contains(view) {
                view.isHidden = true
                wrappers.append(view)
                backView.insertSubview(view, at: 0)
                view.frame = CGRect.init(origin: view.frame.origin, size: backView.bounds.size)
            }
            
            var widgets = [AnimateWidget]()
            
            let animations = keyframe["animations"] as! Array<[String:Any]>
            for animation in animations {
                let widgetView = animation["view"] as! UIView
                var translateY:[CGFloat]?
                var translateX:[CGFloat]?
                var opacity:[CGFloat]?
                var scale:[CGFloat]?
                var rotate:[CGFloat]?

                for (key,value) in animation {
                    if key != "view"{
                        switch key {
                        case "translateY":
                            translateY = convert(value: value, for: key)
                        case "translateX":
                            translateX = convert(value: value, for: key)
                        case "opacity":
                            opacity = convert(value: value, for: key)
                        case "scale":
                            scale = convert(value: value, for: key)
                        case "rotate":
                            rotate = convert(value: value, for: key)
                        default:
                            break
                        }
                    }
                }
                let widget = AnimateWidget.init(view: widgetView, translateY: translateY, translateX: translateX, opacity: opacity, scale: scale, rotate:rotate)
                widgets.append(widget)
            }
            
            let page = AnimateFrame.init(wrapper: view, duration: duration, animations: widgets)
            animateFrames.append(page)
        }
        scrollView.contentSize = CGSize.init(width: windowWidth, height: bodyHeight)
        scrollView.contentOffset = CGPoint.zero
        currentWrapper = wrappers[0];
        currentWrapper?.isHidden = false
    }
    
    /*
     百分比的值要变换为具体的坐标值，对于单值情况，使用默认值作为起始值
     */
    private func convert(value:Any,for key:String) -> [CGFloat] {
        //转换后的值对
        var valuePair = [CGFloat]()
        
        //统一转为数组进行处理
        var values = [Any]()
        if value is Array<Any> {
            values = value as! Array<Any>
        }else{
            //单值情况
            values.append(value)
        }
        
        for val in values {
            var newValue:CGFloat = 0
            if val is String {
                if key == "translateX" {
                    newValue = convertPercentToPx(value: val as! String, axis: "x")
                }else{
                    newValue = convertPercentToPx(value: val as! String, axis: "y")
                }
            }else{
                if val is Int{
                    newValue = CGFloat(val as? Int ?? 0)
                }else if val is Float{
                    newValue = CGFloat(val as? Float ?? 0)
                }else if val is Double{
                    newValue = CGFloat(val as? Double ?? 0)
                }
            }
            valuePair.append(newValue)
        }
        if valuePair.count == 1 {
            valuePair.insert(getDefaultPropertyValue(key), at: 0)
        }
        return valuePair
    }

    // MARK: 滚动处理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stickBackView()
        updatePage()
    }
    
    private func stickBackView(){
        let offset = scrollView.contentOffset
        let size = scrollView.bounds.size
        backView.frame = CGRect.init(x: offset.x, y: offset.y, width: size.width, height: size.height)
    }
    
    private func updatePage() {
      setScrollTops();
      if(scrollTop > 0 && scrollTop <= (bodyHeight - windowHeight)) {
        animateElements();
        setKeyframe();
      }
    }

    private func setScrollTops() {
        scrollTop = scrollView.contentOffset.y;
        relativeScrollTop = scrollTop - prevKeyframesDurations;
    }

    private func animateElements() {
        var view: UIView?
        let animations = animateFrames[currentKeyframe].animations
        for animation in animations {
            //
            view = animation.view
            
            var translateY:CGFloat = 0
            var translateX:CGFloat = 0
            var scale:CGFloat = 0
            var rotate:CGFloat = 0
            var opacity:CGFloat = 0
            
            var transform = CGAffineTransform.identity
            
            if let _ = animation.translateY{
                translateY = calcPropValue(animation: animation, property: "translateY");
            }
            if let _ = animation.translateX{
                translateX = calcPropValue(animation: animation, property: "translateX")
            }
            transform = transform.translatedBy(x:translateX, y: translateY)

            if let _ = animation.scale{
                scale = calcPropValue(animation: animation, property: "scale")
                transform = transform.scaledBy(x: scale, y: scale)
            }
            
            if let _ = animation.rotate{
                rotate = calcPropValue(animation: animation, property: "rotate")
                rotate = rotate/180 * CGFloat.pi
                transform = transform.rotated(by: rotate)
            }
            
            if let _ = animation.opacity{
                opacity = calcPropValue(animation: animation, property: "opacity")
                view?.alpha = opacity
            }
            view?.transform = transform
      }
    }
   
    ///切换动画帧，不一定切换动画页，取决于wrapper是否变化
    private func setKeyframe() {
        let duration = animateFrames[currentKeyframe].duration
        if scrollTop > duration + prevKeyframesDurations {
            prevKeyframesDurations += duration
            currentKeyframe += 1
            showCurrentWrappers();
        } else if(scrollTop < prevKeyframesDurations) {
            currentKeyframe -= 1
            prevKeyframesDurations -= animateFrames[currentKeyframe].duration
            showCurrentWrappers();
        }
    }

    ///检查是否需要变更当前动画页
    private func showCurrentWrappers() {
        let wrapper = animateFrames[currentKeyframe].wrapper
        if wrapper != currentWrapper {
            currentWrapper?.isHidden = true
            wrapper.isHidden = false
            currentWrapper = wrapper
        }
    }
    
    // MARK: helpers
    private func getDefaultPropertyValue(_ property:String) -> CGFloat {
        switch property {
        case "translateX":
            return 0;
        case "translateY":
            return 0;
        case "scale":
            return 1;
        case "rotate":
            return 0;
        case "opacity":
            return 1;
        default:
            return 0
        }
    }
    
    ///根据当前滚动进度计算动画差值
    private func calcPropValue(animation:AnimateWidget, property:String) -> CGFloat{
        let pValue = animation[property]
        if let value = pValue {
            let duration = animateFrames[currentKeyframe].duration
            return easeInOutQuad(relativeScrollTop, value[0], (value[1]-value[0]), duration)
        }else{
            return getDefaultPropertyValue(property)
        }
    }
    
    private func easeInOutQuad(_ t:CGFloat, _ b:CGFloat, _ c:CGFloat, _ d:CGFloat) -> CGFloat{
        return -c/2 * (cos(CGFloat.pi * t/d ) - 1) + b
    }

    ///百分比换算成坐标值
    private func convertPercentToPx(value:String, axis:String) -> CGFloat {
        if(value.hasSuffix("%")){
            let percent = CGFloat(Float(value.dropLast(1))! / 100)
            if axis == "y" {
                return percent * windowHeight
            }else if axis == "x"{
                return percent * windowWidth
            }
        }
        return 0
    }
}
