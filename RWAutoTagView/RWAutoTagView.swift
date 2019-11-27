//
//  RWAutoTagView.swift
//  RWAutoTagViewSwift
//
//  Created by RoverWord on 2019/11/21.
//  Copyright © 2019 RoverWord. All rights reserved.
//

import UIKit

//@discardableResult
/// 协议一： 代理对象  数据源
@objc public protocol RWAutoTagViewDataSource:class {
    /* 🐱 总共有多少个AutoTagButton标签对象 */
    @objc func numberOfAutoTagButton(in autoTageView:RWAutoTagView) -> NSInteger
    /* 🐱 返回AutoTagButton标签对象 */
    @objc func autoTagView(autoTagView:RWAutoTagView, autoTagButtonForAtIndex index:NSInteger) -> RWAutoTagButton
    /*  返回safeAreaLayoutMaxWidth的值  不实现次代理 默认值 UIScreen.main.bounds.width  */
    @objc optional func safeAreaLayoutMaxWidth(in autoTagView:RWAutoTagView) -> CGFloat
    
    /* 🐱 默认值
    width ：safeAreaLayoutMaxWidth
    如果实现代理 '- (CGFloat)safeAreaLayoutMaxWidthInAutoTagView:(RWAutoTagView *)autoTagView;'
    width:代理返回宽度
    宽度不能超过最大显示宽度 */
    @objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat
    /* 🐱 返回平分标签数量 自动计算宽度 不会使用代理'func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger)'返回值*/
    @objc optional func equallyNumberOfAutoTagButton(in autoTagView:RWAutoTagView) -> NSInteger
    
}

/// 协议二：  提供的一些事件时机给 代理对象
@objc public protocol RWAutoTagViewDelegate:NSObjectProtocol {
    /*  RWAutoTagButton 点击事件代理  */
    @objc optional func autoTagView(autoTagView:RWAutoTagView, didSelectAutoTagButtonAtIndex index:NSInteger)
}



/* 🐱 排列样式  */
public enum RWAutoTagViewLineStyle:NSInteger {
    case DynamicSingle = 0
    case DynamicMulti = 1
    case DynamicFixedMulti = 2
    case DynamicFixedEquallyMulti = 3
}

/* 🐱 当前宽度显示的样式  排列样式为 动态显示时候有效 */
public enum RWAutoTagViewFullSafeAreaStyle:NSInteger {
    case MaxWidth = 0
    case AutoWidth = 1
}


public class RWAutoTagView: UIView,RWAutoTagViewProtocol {
    
    /*  存放RWAutoTagButton的数组  */
    private var buttons:NSMutableArray?
    
    private var __dataSource:RWAutoTagViewDataSource?
    weak open var dataSource:RWAutoTagViewDataSource? {
        get {return __dataSource}
        set {__dataSource = newValue
            if (__dataSource != nil) {
                reloadData()
            }
        }
    }
    
    weak open var delegate:RWAutoTagViewDelegate?
    
    /* 内边距 默认 UIEdgeInsetsMake(0,0,0,0) */
    private var __insets:UIEdgeInsets = UIEdgeInsets.init()
    open var insets:UIEdgeInsets! {
        get {return __insets}
        set { if (__insets != newValue) {
                __insets = newValue
                reloadData()
            }
        }
    }
    /* 行间距 默认 lineSpacing = 10.0f */
    private var __lineSpacing:CGFloat = 10.0
    open var lineSpacing:CGFloat! {
        get { return __lineSpacing}
        set {
            if (__lineSpacing != newValue) {
                __lineSpacing = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
                }
            }
        }
    }
    /* 单行时候是否显示行间距  默认 false */
    private var __showSingleLineSpacing:Bool! = false
    open var showSingleLineSpacing:Bool! {
        get {return __showSingleLineSpacing}
        set {
            if (__showSingleLineSpacing != newValue) {
                __showSingleLineSpacing = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
                }
            }
        }
    }
    /* 行内item间距 默认lineitemSpacing = 10.0f */
    private var __lineitemSpacing:CGFloat = 10.0
    open var lineitemSpacing:CGFloat! {
        get {return __lineitemSpacing}
        set {
            if (__lineitemSpacing != newValue) {
                __lineitemSpacing = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
                }
            }
        }
    }
    /* 最大显示宽度
    默认 safeAreaLayoutMaxWidth = UIScreen.main.bounds.width   */
    private var __safeAreaLayoutMaxWidth:CGFloat = UIScreen.main.bounds.width
    open var safeAreaLayoutMaxWidth:CGFloat! {
        get {return __safeAreaLayoutMaxWidth}
        set {
            if (__safeAreaLayoutMaxWidth != newValue) {
                __safeAreaLayoutMaxWidth = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
                }
            }
        }
    }
    /* 🐱 当前宽宽显示的样式 默认 fullSafeAreaStyle = .MaxWidth */
    private var __fullSafeAreaStyle:RWAutoTagViewFullSafeAreaStyle = .MaxWidth
    open var fullSafeAreaStyle:RWAutoTagViewFullSafeAreaStyle! {
        get {return __fullSafeAreaStyle}
        set {
            if (__fullSafeAreaStyle != newValue) {
                __fullSafeAreaStyle = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
//                    self.rw_size = [self intrinsicContentSize];
                }
            }
        }
    }
    /* 🐱 排列样式 默认 lineStyle = .DynamicMulti */
    private var __lineStyle:RWAutoTagViewLineStyle = .DynamicMulti
    open var lineStyle:RWAutoTagViewLineStyle! {
        get {return __lineStyle}
        set {
            if (__lineStyle != newValue) {
                __lineStyle = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    reloadData()
                }
             }
        }
    }
    /* 平分的标签数量 默认0 lineStyle = .DynamicFixedEquallyMulti 值大于0  */
    private var __equallyNumber:NSInteger = 0
    public var equallyNumber:NSInteger! {
        get {return __equallyNumber}
    }
    
    /*  刷新数据  */
    func reloadData() {
        print("刷新数据")
        /*  清除按钮数组  */
        self.buttons?.removeAllObjects()
        /*  清除self.subviews中的RWAutoTagButton对象  */
        for element in self.subviews {
            print("element is \(element.classForCoder)")
            if element.isKind(of: RWAutoTagButton.classForCoder()) {
                element.removeFromSuperview()
            }
        }
        /*  重新创建RWAutoTagButton对象  */
        initAutaTagButton()
    }
    
    private func initAutaTagButton() {
        if self.dataSource == nil {
            return;
        }
        
        var count:NSInteger = 0;
        //  && ((self.dataSource?.numberOfAutoTagButton(in: self)) != nil)
        if self.dataSource != nil {
            count = self.dataSource!.numberOfAutoTagButton(in: self)
        }
        
         for index in 0 ..< count {
            // && (self.dataSource?.autoTagView(autoTagView: self, autoTagButtonForAtIndex:index)) != nil
            if (self.dataSource != nil){
                let autoTagButton:RWAutoTagButton! = self.dataSource!.autoTagView(autoTagView: self, autoTagButtonForAtIndex:index)
                autoTagButton.tag = 1000 + index;
                // && ((self.dataSource?.safeAreaLayoutMaxWidth?(in: self)) != nil)
                if (self.dataSource != nil) {
                    var safeAreaLayoutMaxWidth:CGFloat = (self.dataSource?.safeAreaLayoutMaxWidth?(in: self) ?? self.safeAreaLayoutMaxWidth)
                    if safeAreaLayoutMaxWidth > self.safeAreaLayoutMaxWidth {
                        safeAreaLayoutMaxWidth = self.safeAreaLayoutMaxWidth
                    }
                    autoTagButton.safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth - self.insets.left - self.insets.right
                    
                }
                
                if self.lineStyle == .DynamicFixedMulti ||
                self.lineStyle == .DynamicFixedEquallyMulti {
                    autoTagButton.isDynamicFixed = true;
                    autoTagButton.dynamicFixedSize = CGSize.init(width: autoTagButton.safeAreaLayoutMaxWidth, height: UITableView.automaticDimension)
                    
                    // && ((self.dataSource?.autoTagView?(autoTagView: self, autoTagButtonWidthForAtIndex: index)) != nil)
                    if (self.dataSource != nil) {
                        var width:CGFloat = (self.dataSource?.autoTagView?(autoTagView: self, autoTagButtonWidthForAtIndex: index) ?? self.safeAreaLayoutMaxWidth)
                        if width > autoTagButton.safeAreaLayoutMaxWidth {
                            width = autoTagButton.safeAreaLayoutMaxWidth
                        }
                        autoTagButton.dynamicFixedSize = CGSize.init(width: width, height: UITableView.automaticDimension)
                    }
                    
                    if self.lineStyle == .DynamicFixedEquallyMulti {
                        //  && ((self.dataSource?.equallyNumberOfAutoTagButton?(in: self)) != nil)
                        if (self.dataSource != nil) {
                            __equallyNumber = (self.dataSource?.equallyNumberOfAutoTagButton?(in: self) ?? 1)
                            if __equallyNumber <= 0 {
                                __equallyNumber = 1;
                            }
                            print("autoTagButton.safeAreaLayoutMaxWidth:",autoTagButton.safeAreaLayoutMaxWidth!)
                            
                            let width:CGFloat! = (autoTagButton.safeAreaLayoutMaxWidth - (self.lineitemSpacing * CGFloat(__equallyNumber - 1))) / CGFloat(__equallyNumber)
                            
                            autoTagButton.dynamicFixedSize = CGSize.init(width: width, height: UITableView.automaticDimension)
                        }
                    }
                }
                
                autoTagButton.addTarget(self, action: #selector(autoTagButtonClick(autoTagButton:)), for: .touchUpInside)
                self.addSubview(autoTagButton)
                self.buttons?.add(autoTagButton as RWAutoTagButton)
            }
            print("Count is: \(index)")
        }
        
    }
    
    @objc func autoTagButtonClick(autoTagButton:RWAutoTagButton) {
        /*  代理回调  */
        //&& ((self.delegate?.autoTagView!(autoTagView: self, didSelectAutoTagButtonAtIndex: autoTagButton.tag - 1000)) != nil)
        
        if self.delegate != nil {
            self.delegate!.autoTagView?(autoTagView: self, didSelectAutoTagButtonAtIndex: autoTagButton.tag - 1000)
        }
        /*  Block(闭包) 回调  */
        if (self.autoTagButtonClickBlock != nil) {
            self.autoTagButtonClickBlock(self,autoTagButton.tag - 1000)
        }
    }
    
    typealias clickBlock = (_ autoTagView:RWAutoTagView,_ index:NSInteger) ->Void
    
    public var autoTagButtonClickBlock:clickBlock!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initAttribute()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
    }
    
    convenience public init(lineStyle:RWAutoTagViewLineStyle) {
        self.init()
        self.lineStyle = lineStyle
    }
    
    private func initAttribute() {
        self.buttons = NSMutableArray.init()
        print("initAttribute")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layoutContentSize()
    }
    
    override public var intrinsicContentSize: CGSize {
        get {return self.layoutContentSize()}
    }
    
    @discardableResult
    private func layoutContentSize() ->CGSize {
        var newSize:CGSize = CGSize.zero
        
        switch __lineStyle {
        case .DynamicSingle:
            newSize = reloadAutoTagViewSzie_DynamicSingle()
            break
        case .DynamicMulti:
            newSize = reloadAutoTagViewSzie_DynamicMulti()
            break
        case .DynamicFixedMulti:
            newSize = reloadAutoTagViewSzie_DynamicFixed()
            break
        case .DynamicFixedEquallyMulti:
            newSize = reloadAutoTagViewSzie_DynamicFixed()
            break
        }
        rw_size = newSize
        return newSize
    }
    
    
    /*  .DynamicSingle 计算动态单行  */
    @discardableResult
    private func reloadAutoTagViewSzie_DynamicSingle() -> CGSize {
        if self.buttons?.count == 0 {
            return CGSize.zero
        }
        let subviews:[UIView] = self.subviews
        let lineSpacing:CGFloat = self.lineSpacing
        let top:CGFloat = self.insets.top
        let left:CGFloat = self.insets.left
        let right:CGFloat = self.insets.right
        let bottom:CGFloat = self.insets.bottom
        
        var intrinsicHeight:CGFloat = 0.0
        var intrinsicWidth:CGFloat = left + right
        let current_X:CGFloat = left
        var current_Y:CGFloat = top
        
        var lineMaxWidth:CGFloat = 0.0
        
        var index:NSInteger = 0
        
        for view in subviews {
            if view.isKind(of: RWAutoTagButton.classForCoder()) {
                let autoTagButton:RWAutoTagButton = view as! RWAutoTagButton
                let size:CGSize = autoTagButton.intrinsicContentSize
                var width:CGFloat  = size.width
                let height:CGFloat  = size.height
                
                if ((size.width >= self.safeAreaLayoutMaxWidth) ||
                    (width + left + right) >= self.safeAreaLayoutMaxWidth) {
                    width = self.safeAreaLayoutMaxWidth - left - right;
                    //                intrinsicHeight += height;
                }
                
                
                lineMaxWidth = max(lineMaxWidth, width)
                autoTagButton.frame = CGRect.init(x: current_X, y: current_Y, width: width, height: height)
                current_Y += height
                
                index += 1
                
                if index < subviews.count {
                    current_Y += lineSpacing
                }
            }
        }
        
        intrinsicHeight += (current_Y + bottom)
        lineMaxWidth += (left + right)
        intrinsicWidth = initFullSafeAreaWidth(safeAreaWidth: lineMaxWidth)
        return CGSize.init(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    /*  .DynamicMulti 计算动态多行  */
    @discardableResult
    private func reloadAutoTagViewSzie_DynamicMulti() -> CGSize {
         if self.buttons?.count == 0 {
             return CGSize.zero
         }
        let subviews:[UIView] = self.subviews
        let lineSpacing:CGFloat = self.lineSpacing
        let lineitemSpacing:CGFloat = self.lineitemSpacing
         
        let top:CGFloat = self.insets.top
        let left:CGFloat = self.insets.left
        let right:CGFloat = self.insets.right
        let bottom:CGFloat = self.insets.bottom
         
        var intrinsicHeight:CGFloat = top + bottom
        var intrinsicWidth:CGFloat = left + right
        var current_X:CGFloat = left
        var current_Y:CGFloat = top
         
        var lineMaxWidth:CGFloat = left + right
        var lineMaxHeight:CGFloat = CGFloat.init()
         
        var index:NSInteger = NSInteger.init()
         for view in subviews {
            if view.isKind(of: RWAutoTagButton.classForCoder()) {
                let autoTagButton:RWAutoTagButton = view as! RWAutoTagButton
                let size:CGSize = autoTagButton.intrinsicContentSize;
                var width:CGFloat = size.width;
                let height:CGFloat = size.height;
                let lineitemMaxWidth:CGFloat = current_X + width + right;
                 if ((width >= self.safeAreaLayoutMaxWidth) ||
                     (lineitemMaxWidth >= self.safeAreaLayoutMaxWidth) ||
                     ((lineitemMaxWidth + lineitemSpacing) >= self.safeAreaLayoutMaxWidth)) {
                     current_X = left;
                     
                     current_Y += (lineSpacing + lineMaxHeight)
                     intrinsicHeight += (lineSpacing + lineMaxHeight)
                     width  = min(width, self.safeAreaLayoutMaxWidth - left - right)
                    autoTagButton.frame = CGRect.init(x: current_X, y: current_Y, width: width, height: height)
                     lineMaxHeight = height;
                     current_X += (lineitemSpacing + width)
                     lineMaxWidth = max(lineMaxWidth, current_X)
                     index += 1
                     if (index == subviews.count) {
                         intrinsicHeight += lineMaxHeight;
                     }
                     
                 } else {
                     lineMaxHeight = max(height, lineMaxHeight)
                     autoTagButton.frame = CGRect.init(x: current_X, y: current_Y, width: width, height: height)
//                     [self autoTagButton:autoTagButton frame:CGRectMake(current_X, current_Y, width, height)];
                     current_X += (lineitemSpacing + width);
                     lineMaxWidth = max(lineMaxWidth, current_X)
                     index += 1
                     if (index == subviews.count) {
                         intrinsicHeight += lineMaxHeight;
                     }
                 }
             }
         }

        intrinsicWidth = initFullSafeAreaWidth(safeAreaWidth: lineMaxWidth)
        return CGSize.init(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    /*  .DynamicFixed 计算动态固定多行  */
    @discardableResult
    private func reloadAutoTagViewSzie_DynamicFixed() -> CGSize {
         if self.buttons?.count == 0 {
             return CGSize.zero
         }
        let subviews:[UIView] = self.subviews
        let lineSpacing:CGFloat = self.lineSpacing
        let lineitemSpacing:CGFloat = self.lineitemSpacing
        
        let top:CGFloat = self.insets.top
        let left:CGFloat = self.insets.left
        let right:CGFloat = self.insets.right
        let bottom:CGFloat = self.insets.bottom
        
        var intrinsicHeight:CGFloat = top + bottom
        var intrinsicWidth:CGFloat = left + right
        var current_X:CGFloat = left
        var current_Y:CGFloat = top
        
        var lineMaxWidth:CGFloat = left + right
        var lineMaxHeight:CGFloat = CGFloat.init()
        
        var index:NSInteger  = NSInteger.init()
        for view in subviews {
            if view.isKind(of: RWAutoTagButton.classForCoder()) {
                let autoTagButton:RWAutoTagButton = view as! RWAutoTagButton
                let size:CGSize = autoTagButton.intrinsicContentSize
                var width:CGFloat = size.width
                let height:CGFloat = size.height
                var lineitemMaxWidth:CGFloat  = current_X + width + right
                lineitemMaxWidth = CGFloat(ceilf(Float(lineitemMaxWidth * 100))/100)
                if ((width > self.safeAreaLayoutMaxWidth) ||
                    (lineitemMaxWidth > self.safeAreaLayoutMaxWidth)) {
                    current_X = left;
                    
                    current_Y += (lineSpacing + lineMaxHeight);
                    intrinsicHeight += (lineSpacing + lineMaxHeight);
                    width  = min(width, self.safeAreaLayoutMaxWidth - left - right)
                    autoTagButton.frame = CGRect.init(x: current_X, y: current_Y, width: width, height: height)
                    lineMaxHeight = height
                    current_X += (lineitemSpacing + width)
                    lineMaxWidth = max(lineMaxWidth, current_X)
                    index += 1
                    if (index == subviews.count) {
                        intrinsicHeight += lineMaxHeight
                    }
                    
                } else {
                    lineMaxHeight = max(height, lineMaxHeight)
                    autoTagButton.frame = CGRect.init(x: current_X, y: current_Y, width: width, height: height)
                    current_X += (lineitemSpacing + width);
                    lineMaxWidth = max(lineMaxWidth, current_X)
                    index += 1
                    if (index == subviews.count) {
                        intrinsicHeight += lineMaxHeight;
                    }
                }
            }
        }

        intrinsicWidth = initFullSafeAreaWidth(safeAreaWidth: lineMaxWidth)
        return CGSize.init(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    
    
    /*  根据宽度显示样式 来返回宽度  */
    @discardableResult
    private func initFullSafeAreaWidth(safeAreaWidth:CGFloat) -> CGFloat! {
        var fullSafeAreaWidth:CGFloat! = safeAreaWidth
        switch __fullSafeAreaStyle {
        case .MaxWidth:
            fullSafeAreaWidth = self.safeAreaLayoutMaxWidth
            break
        case .AutoWidth:
            fullSafeAreaWidth = safeAreaWidth;
            break
        }
        return fullSafeAreaWidth
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

protocol RWAutoTagViewProtocol {
    
    /* 内边距 默认 UIEdgeInsetsMake(0,0,0,0) */
    var insets:UIEdgeInsets! {get set}
    /* 行间距 默认 lineSpacing = 10.0f */
    var lineSpacing:CGFloat! {get set}
    /* 单行时候是否显示行间距  默认 false */
    var showSingleLineSpacing:Bool! {get set}
    /* 行内item间距 默认lineitemSpacing = 10.0f */
    var lineitemSpacing:CGFloat! {get set}
    /* 最大显示宽度
    默认 safeAreaLayoutMaxWidth = UIScreen.main.bounds.width   */
    var safeAreaLayoutMaxWidth:CGFloat! {get set}
    /* 🐱 当前宽宽显示的样式 默认 fullSafeAreaStyle = .MaxWidth */
    var fullSafeAreaStyle:RWAutoTagViewFullSafeAreaStyle! {get set}
    /* 🐱 排列样式 默认 lineStyle = .DynamicMulti */
    var lineStyle:RWAutoTagViewLineStyle! {get set}
    /* 平分的标签数量 默认0 lineStyle = .DynamicFixedEquallyMulti 值大于0  */
    var equallyNumber:NSInteger! {get}
}


extension RWAutoTagView {
    open var rw_x:CGFloat {
        get {return self.frame.origin.x}
        set {
            var frame:CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    open var rw_y:CGFloat {
        get {return self.frame.origin.y}
        set {
            var frame:CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    open var rw_w:CGFloat {
        get {return self.frame.size.width}
        set {
            var frame:CGRect = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    open var rw_h:CGFloat {
        get {return self.frame.size.height}
        set {
            var frame:CGRect = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    open var rw_size:CGSize {
        get {return self.frame.size}
        set {
            var frame:CGRect = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    
    open var rw_origin:CGPoint {
        get {return self.frame.origin}
        set {
            var frame:CGRect = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
}



