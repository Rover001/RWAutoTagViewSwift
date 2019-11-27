//
//  ViewController.swift
//  RWAutoTagViewSwiftDemo
//
//  Created by linmao on 2019/11/27.
//  Copyright © 2019 RoverWord. All rights reserved.
//

import UIKit
import RWAutoTagViewSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         let autoTagView = RWAutoTagView.init()
        
        
                autoTagView.lineStyle = .DynamicFixedEquallyMulti
        //        let autoTagView = RWAutoTagView.init(lineStyle: .DynamicMulti)
                autoTagView.backgroundColor = UIColor.red
        //        autoTagView.lineSpacing = 20.00
        autoTagView.dataSource = (self as! RWAutoTagViewDataSource)
        //        autoTagView.delegate = self as RWAutoTagViewDelegate
                self.view.addSubview(autoTagView)
                
                print(autoTagView.insets as Any,autoTagView.classForCoder)
                autoTagView.insets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
                print(autoTagView.insets as Any,autoTagView.classForCoder)
                
                autoTagView.autoTagButtonClickBlock = {(autoTagView,index)->Void in
                    print("autoTagButtonClickBlock",autoTagView,index)
                }
                
    }


}

