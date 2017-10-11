//
//  JDBreaksLoading.swift
//  JDBreaksLoading
//
//  Created by 郭介騵 on 2016/12/14.
//  Copyright © 2016年 james12345. All rights reserved.
//

import UIKit
import SpriteKit

struct JDBreaksGameConfiguration {
    var paddle_color:UIColor = UIColor.white
    var ball_color:UIColor = UIColor.white
    var block_color:UIColor = UIColor.white
    var blocks_count:Int = 3
}

class JDBreaksLoading:UIView
{
    var skview:SKView!
    var skscene:JDBreaksScene!
    var indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var configuration:JDBreaksGameConfiguration = JDBreaksGameConfiguration(paddle_color: UIColor.white, ball_color: UIColor.white, block_color: UIColor.white, blocks_count: 3)
    
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    
        let skviewframe:CGRect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        skscene = JDBreaksScene(size: skviewframe.size)
        skview.presentScene(skscene)
    }
    
    init(frame: CGRect,configuration: JDBreaksGameConfiguration)
    {
        super.init(frame: frame)
         initView()
        
        let skviewframe:CGRect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        skscene = JDBreaksScene(size: skviewframe.size, configuration: configuration)
        skview.presentScene(skscene)
    }
    
    func initView()
    {
        self.frame = frame
        self.backgroundColor = UIColor.clear
        
        self.layer.cornerRadius = 0.25 * self.frame.width
        
        let skviewframe:CGRect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        skview = SKView(frame: skviewframe)
        skview.backgroundColor = UIColor.clear
        skview.layer.cornerRadius =  0.25 * self.frame.width
        skview.alpha = 0.8
        
        let bg = UIView(frame: skviewframe)
        bg.backgroundColor = UIColor.black
        bg.alpha = 0.5
        bg.layer.cornerRadius = 0.25 * self.frame.width
        
        self.addSubview(bg)
        self.addSubview(skview)
        
        indicator.frame = CGRect(x: (self.frame.width - 30) * 0.5, y: (self.frame.height - 30) * 0.5, width: 30, height: 30)
        indicator.startAnimating()
        self.addSubview(indicator)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

