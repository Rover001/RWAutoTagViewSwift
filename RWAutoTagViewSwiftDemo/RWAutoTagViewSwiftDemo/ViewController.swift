//
//  ViewController.swift
//  RWAutoTagViewSwiftDemo
//
//  Created by linmao on 2019/11/27.
//  Copyright © 2019 RoverWord. All rights reserved.
//

import UIKit
import RWAutoTagViewSwift

class ViewController: UIViewController,RWAutoTagViewDataSource,RWAutoTagViewDelegate {

    func numberOfAutoTagButton(in autoTageView: RWAutoTagView) -> NSInteger {
            return 3
        }
        
        func autoTagView(autoTagView: RWAutoTagView, autoTagButtonForAtIndex index: NSInteger) -> RWAutoTagButton {
            let button:RWAutoTagButton =  RWAutoTagButton.init(type: .custom)
            
            button.backgroundColor = UIColor.orange
            button.autoTagButtonStyle = .Mingle
            button.imageStyle = .Top
            button.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
    //        button.safeAreaLayoutMaxWidth = 100
            button.setTitle("只有文字只只jhgfhjgff", for: .normal)
    //        button.setImage(UIImage.init(named: "RWAutoTag"), for: .normal)
    //        button.setImage(RWAutoTagBundle.rw_autotagImage, for: .normal)
            
            return button
        }
        
        func autoTagView(autoTagView: RWAutoTagView, autoTagButtonWidthForAtIndex index: NSInteger) -> CGFloat {
            return 100
        }
        
        func equallyNumberOfAutoTagButton(in autoTagView: RWAutoTagView) -> NSInteger {
            return 3
        }
        
        func autoTagView(autoTagView: RWAutoTagView, didSelectAutoTagButtonAtIndex index: NSInteger) {
            print("didSelectAutoTagButtonAtIndex:",index)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            var autoTagView = RWAutoTagView.init(frame: CGRect.init(x: 0.0, y: 100.0, width: self.view.bounds.width, height: 300.0))
//            autoTagView = RWAutoTagView.init(lineStyle: .DynamicSingle)
//            autoTagView.lineStyle = .DynamicFixedEquallyMulti
    //        let autoTagView = RWAutoTagView.init(lineStyle: .DynamicMulti)
            autoTagView.backgroundColor = UIColor.red
    //        autoTagView.lineSpacing = 20.00
            autoTagView.dataSource = self as RWAutoTagViewDataSource
            autoTagView.delegate = self as RWAutoTagViewDelegate
            self.view.addSubview(autoTagView)
            
            print(autoTagView.insets as Any,autoTagView.classForCoder)
            autoTagView.insets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
            print(autoTagView.insets as Any,autoTagView.classForCoder)
            
//            autoTagView.autoTagButtonClickBlock = {(autoTagView,index)->Void in
//                print("autoTagButtonClickBlock",autoTagView,index)
//            }
            
    //        UITableView
        }

}

