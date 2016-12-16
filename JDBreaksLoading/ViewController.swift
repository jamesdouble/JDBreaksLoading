//
//  ViewController.swift
//  JDBreaksLoading
//
//  Created by 郭介騵 on 2016/12/14.
//  Copyright © 2016年 james12345. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let frame:CGRect = CGRect(x:  (self.view.frame.width - 170) * 0.5 , y: (self.view.frame.height - 170) * 0.5, width: 170 , height: 170 )
        let config:JDBreaksGameConfiguration = JDBreaksGameConfiguration(paddle_color: UIColor.white, ball_color:  UIColor.white, block_color:  UIColor.white, blocks_count: 3)
        let jd:JDBreaksLoading = JDBreaksLoading(frame: frame, configuration: config)
        
        self.view.addSubview(jd)
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

