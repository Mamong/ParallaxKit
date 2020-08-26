//
//  SlideView.swift
//  Parallax
//
//  Created by marco on 2020/8/25.
//  Copyright © 2020 flywire. All rights reserved.
//

import UIKit

class IntroView: UIView {
    var nameLabel:UILabel
    var descLabel:UILabel

    override init(frame: CGRect) {
        let namelabel = UILabel.init(frame: CGRect.init(x: 100, y: 100, width: 200, height: 100))
        namelabel.text = "Parallax Demo"
        namelabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        namelabel.textColor = UIColor.white
        self.nameLabel = namelabel
        
        let descLabel = UILabel.init(frame: CGRect.init(x: 100, y: 200, width: 200, height: 100))
        descLabel.text = "An experiment by Dave Gamache"
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor.white
        self.descLabel = descLabel
        
        super.init(frame: frame)
        addSubview(namelabel)
        addSubview(descLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ExplosionView: UIView {
    
    var explosionLabel:UILabel
    var matrixView:UIView
    
    var domExplosionList = [UIView]()

    override init(frame: CGRect) {
        let explosionLabel = UILabel.init(frame: CGRect.init(x: 10, y: 400, width: 300, height: 100))
        explosionLabel.text = "Here's an example of 16 elements scaling, fading and moving at once."
        explosionLabel.font = UIFont.systemFont(ofSize: 15)
        explosionLabel.textColor = UIColor.white
        explosionLabel.alpha = 0
        self.explosionLabel = explosionLabel
        
        //4x4纯色方块
        let matrixView = UIView.init(frame: CGRect.init(x: 100, y: 500, width: 180, height: 320))
        matrixView.alpha = 0
        self.matrixView = matrixView
        
        for row in 0...1{
            for column in 0...1{
                let item = UIView.init(frame: CGRect.init(x: column*90, y: row*90, width: 80, height: 80))
                item.backgroundColor = UIColor.white
                matrixView.addSubview(item)
                domExplosionList.append(item)
            }
        }
        
        
        super.init(frame: frame)
        addSubview(explosionLabel)
        addSubview(matrixView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class imagesView: UIView {
    
    var mediumHomepage:UIImageView
    
    var iphoneView:UIView
    var iphoneFrameView:UIImageView
    var frameContentView:UIView
    var profileView:UIImageView
    var dotcomView:UIImageView

    override init(frame: CGRect) {
        let mediumHomepage = UIImageView.init(frame: CGRect.init(x: 100, y: 647, width: 250, height: 250*1.13))
        mediumHomepage.image = UIImage.init(named: "oversized-raw-homepage.jpg")
        self.mediumHomepage = mediumHomepage
        
        let iphoneView = UIView.init(frame: CGRect.init(x: 80, y: 647, width: 100, height: 100*2.117))
        self.iphoneView = iphoneView
        
        
        let iphoneFrameView = UIImageView.init(frame: iphoneView.bounds)
        iphoneFrameView.image = UIImage.init(named: "iphoneframe.png")
        self.iphoneFrameView = iphoneFrameView
        
        
        let frameContentView = UIView.init(frame: CGRect.init(x: 8, y: 30, width: 84, height: 155))
        frameContentView.layer.masksToBounds = true
        self.frameContentView = frameContentView
        
        let profileView = UIImageView.init(frame: frameContentView.bounds)
        profileView.image = UIImage.init(named: "medium-profile-iphone-fullsize.jpg")
        profileView.tag = 1000
        self.profileView = profileView
        
        let dotcomView = UIImageView.init(frame: frameContentView.bounds)
        dotcomView.image = UIImage.init(named: "davegamache-rotated.jpg")
        self.dotcomView = dotcomView
        
        super.init(frame: frame)
        addSubview(mediumHomepage)
        addSubview(iphoneView)
        iphoneView.addSubview(iphoneFrameView)
        iphoneView.addSubview(frameContentView)
        frameContentView.addSubview(dotcomView)
        frameContentView.addSubview(profileView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
