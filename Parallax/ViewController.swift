//
//  ViewController.swift
//  Parallax
//
//  Created by marco on 2020/8/23.
//  Copyright © 2020 flywire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView
    
    var pm:ParallaxManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.delegate = self
        scrollView.frame = view.bounds
        view.addSubview(self.scrollView)
        
        let intro = IntroView.init(frame: CGRect.zero)
        let explosion = ExplosionView.init(frame: CGRect.zero)
        let images = imagesView.init(frame: CGRect.zero)
        
        pm = ParallaxManager.init(with: scrollView, direction: .down)
        pm?.backgroundImage = UIImage.init(named: "bg2.jpg")
        
        pm?.addKeyFrameAnimation(animation: [
            "wrapper" : intro,
            "duration" : "100%",
            "animations" :  [
                [
                    "view"    : intro.nameLabel,
                    "translateY"  : -140,
                    "opacity"     : 0
                ] , [
                    "view"    : intro.descLabel,
                    "translateY"  : -110,
                    "opacity"     : 0
                ]
            ]
        ])
        
        pm?.addKeyFrameAnimation(animation: [
            "wrapper" : explosion,
            "duration" : "150%",
            "animations" :  [
                [
                    "view"    : explosion.explosionLabel,
                    "translateY"  : "-25%",
                    "opacity"     : [0, 1.75] // hack to accelrate opacity speed
                ]
                , [
                    "view"    : explosion.matrixView,
                    "translateY"  : "-70%",
                    "opacity"     : [0, 1] // hack to accelrate opacity speed
                ]
            ]
        ])
        
        pm?.addKeyFrameAnimation(animation: [
            "wrapper" : explosion,
            "duration" : "150%",
            "animations" :  [
                [
                    "view"    : explosion.domExplosionList[0],
                    "translateY"  : "-15%",
                    "translateX"  : "-10%",
                    "opacity"     : [1, 0],
                    "scale"       : 2,
                ] , [
                    "view"    : explosion.domExplosionList[1],
                    "translateY"  : "-15%",
                    "translateX"  : "10%",
                    "opacity"     : [1, 0] // hack to decelrate opacity speed
                ] , [
                    "view"    : explosion.domExplosionList[2],
                    "translateY"  : "-2%",
                    "translateX"  : "-15%",
                    "opacity"     : [1, 0], // hack to accelrate opacity speed
                    "scale"       : 2,
                ] , [
                    "view"    : explosion.domExplosionList[3],
                    "translateY"  : "-2%",
                    "translateX"  : "15%",
                    "opacity"     : [1, 0], // hack to accelrate opacity speed
                    "scale"       : 1.2,
                ]
            ]
        ])
        
        pm?.addKeyFrameAnimation(animation: [
            "wrapper" : images,
            "duration" : "150%",
            "animations" :  [
                [
                    "view"    : images.mediumHomepage,
                    "translateY"  : "-90%"
                ] , [
                    "view"    : images.iphoneView,
                    "translateY"  : "-66%"
                ]
            ]
        ])
        
        pm?.addKeyFrameAnimation(animation: [
            "wrapper" : images,
            "duration" : "75%",
            "animations" :  []
        ])
        
        pm?.addKeyFrameAnimation(animation: [
            "wrapper" : images,
            "duration" : "150%",
            "animations" :  [
                [
                    "view"    : images.mediumHomepage,
                    "translateY"  : ["-90%", "-90%"],
                    "scale"       : 0.8,
                    "opacity"     : -0.75
                ] , [
                    "view"    : images.iphoneView,
                    "translateY"  : ["-66%", "-90%"],
                    "translateX"  : "15%",
                    "rotate"      : -90,
                    "scale"       : 1.3
                ],
                [
                    "view"    : images.profileView,
                    "scale"       : 0.9,
                    "translateX"  : "30%",
                ]
                , [
                    "view"    : images.dotcomView,
                    "scale"       : [0.5, 1]
                ]
            ]
        ])
        
        pm?.addKeyFrameAnimation(animation: [
            "wrapper" : images,
            "duration" : "40%",
            "animations" :  []
        ])
        
        pm?.addKeyFrameAnimation(animation: [
            "wrapper" : images,
            "duration" : "150%",
            "animations" :  [
                [
                    "view"    : images.iphoneView,
                    "translateY"  : ["-90%", "-66%"],
                    "translateX"  : ["15%", "15%"],
                    "rotate"      : [-90, -90],
                    "scale"       : [1.3, 1.3]
                ] , [
                    "view"    : images.profileView,
                    "translateX"  : ["30%", "30%"]
                ] , [
                    "view"    : images.dotcomView,
                    "scale"       : [1, 1]
                ]
            ]
        ])
        
        pm?.addKeyFrameAnimation(animation: [
              //"wrapper" : explosion,
                "duration" : "100%",
                "animations" :  []
        ])
        pm?.generateKeyFrameAnimations()
    }
    
    required init?(coder: NSCoder) {
        self.scrollView = UIScrollView.init()
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //滚动代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pm?.scrollViewDidScroll(scrollView)
    }
}

