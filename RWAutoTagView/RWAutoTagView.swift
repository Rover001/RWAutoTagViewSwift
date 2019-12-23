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
    /*  返回rw_safeAreaLayoutMaxWidth的值  不实现次代理 默认值 UIScreen.main.bounds.width  */
    @objc optional func safeAreaLayoutMaxWidth(in autoTagView:RWAutoTagView) -> CGFloat
    
    /*
     rw_RangeStyle = DynamicFixed | DynamicFixedEqually 时候
     以下代理才会有效 */

    /* 🐱 返回值 固定AutoTagButton标签对象的宽度 高度是动态的UITableViewAutomaticDimension
     组成的AutoTagButton标签对象的Size为： CGSizeMake(width, UITableViewAutomaticDimension)

     默认值：rw_safeAreaLayoutMaxWidth
     如果实现代理 '@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat'
     width:代理返回宽度
     
     宽度不能超过最大显示宽度(rw_safeAreaLayoutMaxWidth) */
    @objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat
    
    /* 🐱 返回值 固定AutoTagButton标签对象的高度 宽度是rw_safeAreaLayoutMaxWidth
        组成的AutoTagButton标签对象的Size为： CGSizeMake(rw_safeAreaLayoutMaxWidth, height)

        如果实现代理 '@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonHeightForAtIndex index:NSInteger) -> CGFloat'
        height:代理返回高度

        宽度不能超过最大显示宽度(rw_safeAreaLayoutMaxWidth) */
    
    @objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonHeightForAtIndex index:NSInteger) -> CGFloat
    
    /* 🐱 返回值  固定AutoTagButton标签对象的Size 这代理的优先级高于单独返回宽高的代理。
    如果实现了这个代理
    那么代理'@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat'将失效
    那么代理'@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonHeightForAtIndex index:NSInteger) -> CGFloat'将失效
    */
    @objc optional func autoTagView(autoTagView:RWAutoTagView,autoTagButtonSizeForAtIndex index:NSInteger) -> CGSize
    
    /* 🐱 返回平分标签数量 自动计算宽度  这里计算的宽度优先级最高
    rw_RangeStyle = DynamicFixedEqually
    如果两个代理没有实现 那么表示高度动态
    '@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonHeightForAtIndex index:NSInteger) -> CGFloat'
    '@objc optional func autoTagView(autoTagView:RWAutoTagView,autoTagButtonSizeForAtIndex index:NSInteger) -> CGSize'
    
    1.那么代理'@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat'将失效
    2.实现代理'@objc optional func autoTagView(autoTagView:RWAutoTagView,autoTagButtonSizeForAtIndex index:NSInteger) -> CGSize'只会使用高度，宽度是无效的
     */
    @objc optional func equallyNumberOfAutoTagButton(in autoTagView:RWAutoTagView) -> NSInteger
    
}

/// 协议二：  提供的一些事件时机给 代理对象
@objc public protocol RWAutoTagViewDelegate:NSObjectProtocol {
    /*  RWAutoTagButton 点击事件代理  */
    @objc optional func autoTagView(autoTagView:RWAutoTagView, didSelectAutoTagButtonAtIndex index:NSInteger)
}



/* 🐱 排列样式  */
public enum RWAutoTagViewLineStyle:NSInteger {
    /* 🐱 动态-单行显示  单个AutoTagButton标签显示一行 */
    case DynamicSingle = 0
    /* 🐱 动态-多行显示  根据AutoTagButton标签宽度来计算的 */
    case DynamicMulti = 1
    
    /* 🐱 宽度不能超过最大显示宽度 */
    /* 🐱 动态-固定AutoTagButton标签宽度-多行显示
     属于动态多行显示中特殊的存在，设置AutoTagButton标签固定宽度
     需实现代理 '@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat'
    */
    case DynamicFixedMulti = 2
    /* 🐱 动态-固定平分宽度-多行显示
    属于RWAutoTagViewLineStyle_Fixed 中特殊的一种  每行中的AutoTagButton标签宽度相等
    代理'@objc optional func equallyNumberOfAutoTagButton(in autoTagView:RWAutoTagView) -> NSInteger' 返回每行平分标签的数量 可用equallyNumber（可读）获取
    
    
    一、如果实现代理'@objc optional func equallyNumberOfAutoTagButton(in autoTagView:RWAutoTagView) -> NSInteger'
       那么代理'@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat' 可不实现
    
    二、代理'@objc optional func equallyNumberOfAutoTagButton(in autoTagView:RWAutoTagView) -> NSInteger' 没有实现，
       可实现代理'@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat' 而达到效果
       那就是每行返回的CGSzie必须宽度相等
       比如：每行显示3个
       height：AutoTagButton标签高
       width ：safeAreaLayoutMaxWidth
       如果实现代理 '@objc optional func safeAreaLayoutMaxWidth(in autoTagView:RWAutoTagView) -> CGFloat'
       width:代理返回宽度
       
       CGSizeMake(width/3, height) 这样就可以达到效果
    */
    case DynamicFixedEquallyMulti = 3
}

public enum RWAutoTagViewRangeStyle:NSInteger {
    /* 🐱 动态-单行单个显示  单个AutoTagButton标签排列一行
    AutoTagButton的最大宽度不能超过rw_safeAreaLayoutMaxWidth */
    case DynamicSingle = 0
    /* 🐱 动态-单行多个显示  根据AutoTagButton标签宽度来计算的 一行一个或者一行多个  默认*/
    case DynamicMulti = 1
    /* 🐱 动态-固定大小显示 */
    case DynamicFixed = 2
    /* 🐱 动态-固定大小宽度平分显示  */
    case DynamicFixedEqually = 3
    
}

/* 🐱 当前宽度显示的样式  排列样式为 动态显示时候有效 */
public enum RWAutoTagViewFullSafeAreaStyle:NSInteger {
    /* 默认 根据safeAreaLayoutMaxWidth值为宽度  */
    case MaxWidth = 0
    /* 自动根据控件布局来计算宽度 但不超过最大显示宽度 */
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
    private var __rw_insets:UIEdgeInsets = UIEdgeInsets.init()
    open var rw_insets:UIEdgeInsets! {
        get {return __rw_insets}
        set { if (__rw_insets != newValue) {
                __rw_insets = newValue
                reloadData()
            }
        }
    }
    /* 行间距 默认 rw_lineSpacing = 10.0f */
    private var __rw_lineSpacing:CGFloat = 10.0
    open var rw_lineSpacing:CGFloat! {
        get { return __rw_lineSpacing}
        set {
            if (__rw_lineSpacing != newValue) {
                __rw_lineSpacing = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
                }
            }
        }
    }
    /* 单行时候是否显示行间距  默认 false */
    private var __rw_showSingleLineSpacing:Bool! = false
    open var rw_showSingleLineSpacing:Bool! {
        get {return __rw_showSingleLineSpacing}
        set {
            if (__rw_showSingleLineSpacing != newValue) {
                __rw_showSingleLineSpacing = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
                }
            }
        }
    }
    /* 行内item间距 默认rw_itemSpacing = 10.0f */
    private var __rw_lineitemSpacing:CGFloat = 10.0
    open var rw_itemSpacing:CGFloat! {
        get {return __rw_lineitemSpacing}
        set {
            if (__rw_lineitemSpacing != newValue) {
                __rw_lineitemSpacing = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
                }
            }
        }
    }
    /* 最大显示宽度
    默认 rw_safeAreaLayoutMaxWidth = UIScreen.main.bounds.width   */
    private var __rw_safeAreaLayoutMaxWidth:CGFloat = UIScreen.main.bounds.width
    open var rw_safeAreaLayoutMaxWidth:CGFloat! {
        get {return __rw_safeAreaLayoutMaxWidth}
        set {
            if (__rw_safeAreaLayoutMaxWidth != newValue) {
                __rw_safeAreaLayoutMaxWidth = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
                }
            }
        }
    }
    /* 🐱 当前宽宽显示的样式 默认 fullSafeAreaStyle = .MaxWidth */
    private var __rw_fullSafeAreaStyle:RWAutoTagViewFullSafeAreaStyle = .MaxWidth
    open var rw_fullSafeAreaStyle:RWAutoTagViewFullSafeAreaStyle! {
        get {return __rw_fullSafeAreaStyle}
        set {
            if (__rw_fullSafeAreaStyle != newValue) {
                __rw_fullSafeAreaStyle = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    self.setNeedsLayout()
//                    self.rw_size = [self intrinsicContentSize];
                }
            }
        }
    }
    /* 🐱 排列样式 默认 rw_rangeStyle = .DynamicMulti */
    private var __rw_rangeStyle:RWAutoTagViewRangeStyle = .DynamicMulti
    open var rw_rangeStyle: RWAutoTagViewRangeStyle! {
        get {return __rw_rangeStyle}
        set {
            if (__rw_rangeStyle != newValue) {
                __rw_rangeStyle = newValue
                if ((buttons != nil) && (buttons?.count ?? 0 > 0)) {
                    reloadData()
                }
             }
        }
    }
    
    /* 平分的标签数量 默认0 lineStyle = .DynamicFixedEquallyMulti 值大于0  */
    private var __rw_equallyNumber:NSInteger = 0
    public var rw_equallyNumber:NSInteger! {
        get {return __rw_equallyNumber}
    }
    
    /*  刷新数据  */
    private func reloadData() {
//        print("刷新数据")
        /*  清除按钮数组  */
        self.buttons?.removeAllObjects()
        /*  清除self.subviews中的RWAutoTagButton对象  */
        for element in self.subviews {
//            print("element is \(element.classForCoder)")
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
                autoTagButton.rw_isDynamicFixed = false
                if autoTagButton.tag <= 0 {
                    autoTagButton.tag = index + 10000
                }
                autoTagButton.rw_safeAreaLayoutMaxWidth = self.rw_safeAreaLayoutMaxWidth - self.rw_insets.left - self.rw_insets.right;
                // && ((self.dataSource?.safeAreaLayoutMaxWidth?(in: self)) != nil)
                if (self.dataSource != nil && (((self.dataSource?.safeAreaLayoutMaxWidth?(in: self)) != nil))) {
                    var rw_safeAreaLayoutMaxWidth:CGFloat = (self.dataSource?.safeAreaLayoutMaxWidth?(in: self))!
                    if rw_safeAreaLayoutMaxWidth > self.rw_safeAreaLayoutMaxWidth {
                        rw_safeAreaLayoutMaxWidth = self.rw_safeAreaLayoutMaxWidth
                    }
                    autoTagButton.rw_safeAreaLayoutMaxWidth = rw_safeAreaLayoutMaxWidth - self.rw_insets.left - self.rw_insets.right
                }
                
                if self.rw_rangeStyle == .DynamicFixed ||
                    self.rw_rangeStyle == .DynamicFixedEqually {
                    var isFixedEqually:Bool = false
                    var isFixed:Bool = false
                    var autoTagButton_Width:CGFloat = autoTagButton.rw_safeAreaLayoutMaxWidth;
                    var autoTagButton_Height:CGFloat = UITableView.automaticDimension;
                    autoTagButton.rw_dynamicFixedSize = CGSize.init(width: autoTagButton_Width, height: autoTagButton_Height)
                    autoTagButton.rw_isDynamicFixed = true;
                    // && ((self.dataSource?.autoTagView?(autoTagView: self, autoTagButtonWidthForAtIndex: index)) != nil)
                    
                    /*  代理返回宽高  */
                    if (self.dataSource != nil && ((self.dataSource?.autoTagView?(autoTagView: self, autoTagButtonSizeForAtIndex: index)) != nil)) {
                        
                        let newSize:CGSize = (self.dataSource?.autoTagView?(autoTagView: self, autoTagButtonSizeForAtIndex: index))!
                        autoTagButton_Width = newSize.width
                        autoTagButton_Height = newSize.height
                        if autoTagButton_Width > autoTagButton.rw_safeAreaLayoutMaxWidth {
                            autoTagButton_Width = autoTagButton.rw_safeAreaLayoutMaxWidth
                        }
                        isFixed = true
                        isFixedEqually = true
                    } else {
                        /*  代理返回宽度  */
                        if self.dataSource != nil && ((self.dataSource?.autoTagView?(autoTagView: self, autoTagButtonWidthForAtIndex: index)) != nil) {
                            autoTagButton_Width = (self.dataSource?.autoTagView?(autoTagView: self, autoTagButtonWidthForAtIndex: index))!
                            if autoTagButton_Width > autoTagButton.rw_safeAreaLayoutMaxWidth {
                                autoTagButton_Width = autoTagButton.rw_safeAreaLayoutMaxWidth
                            }
                            isFixed = true
                        }
                        
                        /*  代理返回高度  */
                        if self.dataSource != nil && ((self.dataSource?.autoTagView?(autoTagView: self, autoTagButtonHeightForAtIndex: index)) != nil) {
                            let height:CGFloat = (self.dataSource?.autoTagView?(autoTagView: self, autoTagButtonHeightForAtIndex: index) ?? UITableView.automaticDimension)
                            autoTagButton_Height = height
                            isFixed = true
                            isFixedEqually = true
                        }
                    }
                    autoTagButton.rw_dynamicFixedSize = CGSize.init(width: autoTagButton_Width, height: autoTagButton_Height)
                    assert(isFixed == true, "请实现代理🐱\n🐱🐱@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat🐱🐱\n🐱或者🐱\n🐱🐱@objc optional func autoTagView(autoTagView:RWAutoTagView,autoTagButtonSizeForAtIndex index:NSInteger) -> CGSize🐱🐱\n🐱")
                    
                    
                    if self.rw_rangeStyle == .DynamicFixedEqually {
                        //  && ((self.dataSource?.equallyNumberOfAutoTagButton?(in: self)) != nil)
                        if (self.dataSource != nil) {
                            __rw_equallyNumber = (self.dataSource?.equallyNumberOfAutoTagButton?(in: self) ?? 1)
                            if __rw_equallyNumber <= 0 {
                                __rw_equallyNumber = 1;
                            }
                            isFixedEqually = true
//                            print("autoTagButton.safeAreaLayoutMaxWidth:",autoTagButton.rw_safeAreaLayoutMaxWidth!)
                            
                            autoTagButton_Width = (autoTagButton.rw_safeAreaLayoutMaxWidth - (self.rw_itemSpacing * CGFloat(__rw_equallyNumber - 1))) / CGFloat(__rw_equallyNumber)
                            autoTagButton.rw_dynamicFixedSize = CGSize.init(width: autoTagButton_Width, height: autoTagButton_Height)
                        }
                        
                        assert(isFixedEqually == true, "请实现代理🐱\n🐱🐱@objc optional func autoTagView(autoTagView:RWAutoTagView, autoTagButtonWidthForAtIndex index:NSInteger) -> CGFloat🐱🐱\n🐱或者🐱\n🐱🐱@objc optional func autoTagView(autoTagView:RWAutoTagView,autoTagButtonSizeForAtIndex index:NSInteger) -> CGSize🐱🐱\n🐱")
                    }
                }
                
                autoTagButton.addTarget(self, action: #selector(autoTagButtonClick(autoTagButton:)), for: .touchUpInside)
                print("autoTagButton:", autoTagButton.intrinsicContentSize.width,autoTagButton.intrinsicContentSize.height)
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
    
    public typealias clickBlock = (_ autoTagView:RWAutoTagView,_ index:NSInteger) ->Void
    
    public var autoTagButtonClickBlock:clickBlock!

    required public init? (coder: NSCoder) {
        super.init(coder: coder)
        initAttribute()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
    }
    
    convenience public init(rangeStyle:RWAutoTagViewRangeStyle) {
        self.init()
        self.rw_rangeStyle = rangeStyle
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
        
        switch __rw_rangeStyle {
        case .DynamicSingle:
            newSize = reloadAutoTagViewSzie_DynamicSingle()
            break
        case .DynamicMulti:
            newSize = reloadAutoTagViewSzie_DynamicMulti()
            break
        case .DynamicFixed:
            newSize = reloadAutoTagViewSzie_DynamicFixed()
            break
        case .DynamicFixedEqually:
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
        let lineSpacing:CGFloat = self.rw_lineSpacing
        let top:CGFloat = self.rw_insets.top
        let left:CGFloat = self.rw_insets.left
        let right:CGFloat = self.rw_insets.right
        let bottom:CGFloat = self.rw_insets.bottom
        
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
                
                if ((size.width >= self.rw_safeAreaLayoutMaxWidth) ||
                    (width + left + right) >= self.rw_safeAreaLayoutMaxWidth) {
                    width = self.rw_safeAreaLayoutMaxWidth - left - right;
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
        let lineSpacing:CGFloat = self.rw_lineSpacing
        let itemSpacing:CGFloat = self.rw_itemSpacing
         
        let top:CGFloat = self.rw_insets.top
        let left:CGFloat = self.rw_insets.left
        let right:CGFloat = self.rw_insets.right
        let bottom:CGFloat = self.rw_insets.bottom
         
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
                 if ((width >= self.rw_safeAreaLayoutMaxWidth) ||
                     (lineitemMaxWidth >= self.rw_safeAreaLayoutMaxWidth) ||
                     ((lineitemMaxWidth + itemSpacing) >= self.rw_safeAreaLayoutMaxWidth)) {
                     current_X = left
                    if index > 0 && index < subviews.count {
                        current_Y += lineSpacing;
                        intrinsicHeight += lineSpacing;
                    }
                     
                     current_Y += lineMaxHeight;
                     intrinsicHeight += lineMaxHeight;
                     width  = min(width, self.rw_safeAreaLayoutMaxWidth - left - right)
                    autoTagButton.frame = CGRect.init(x: current_X, y: current_Y, width: width, height: height)
                     lineMaxHeight = height;
                     current_X += (itemSpacing + width)
                     lineMaxWidth = max(lineMaxWidth, current_X)
                     index += 1
                     if (index == subviews.count) {
                         intrinsicHeight += lineMaxHeight;
                     }
                     
                 } else {
                     lineMaxHeight = max(height, lineMaxHeight)
                     autoTagButton.frame = CGRect.init(x: current_X, y: current_Y, width: width, height: height)
//                     [self autoTagButton:autoTagButton frame:CGRectMake(current_X, current_Y, width, height)];
                     current_X += (itemSpacing + width);
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
        let lineSpacing:CGFloat = self.rw_lineSpacing
        let itemSpacing:CGFloat = self.rw_itemSpacing
        
        let top:CGFloat = self.rw_insets.top
        let left:CGFloat = self.rw_insets.left
        let right:CGFloat = self.rw_insets.right
        let bottom:CGFloat = self.rw_insets.bottom
        
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
                if ((width > self.rw_safeAreaLayoutMaxWidth) ||
                    (lineitemMaxWidth > self.rw_safeAreaLayoutMaxWidth)) {
                    current_X = left;
                    
                    current_Y += (lineSpacing + lineMaxHeight);
                    intrinsicHeight += (lineSpacing + lineMaxHeight);
                    width  = min(width, self.rw_safeAreaLayoutMaxWidth - left - right)
                    autoTagButton.frame = CGRect.init(x: current_X, y: current_Y, width: width, height: height)
                    lineMaxHeight = height
                    current_X += (itemSpacing + width)
                    lineMaxWidth = max(lineMaxWidth, current_X)
                    index += 1
                    if (index == subviews.count) {
                        intrinsicHeight += lineMaxHeight
                    }
                    
                } else {
                    lineMaxHeight = max(height, lineMaxHeight)
                    autoTagButton.frame = CGRect.init(x: current_X, y: current_Y, width: width, height: height)
                    current_X += (itemSpacing + width);
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
        switch __rw_fullSafeAreaStyle {
        case .MaxWidth:
            fullSafeAreaWidth = self.rw_safeAreaLayoutMaxWidth
            break
        case .AutoWidth:
            fullSafeAreaWidth = safeAreaWidth;
            break
        }
        return fullSafeAreaWidth
    }
    
}

protocol RWAutoTagViewProtocol {
    
    /* 内边距 默认 UIEdgeInsetsMake(0,0,0,0) */
    var rw_insets:UIEdgeInsets! {get set}
    /* 行间距 默认 rw_lineSpacing = 10.0f */
    var rw_lineSpacing:CGFloat! {get set}
    /* 单行时候是否显示行间距  默认 false */
    var rw_showSingleLineSpacing:Bool! {get set}
    /* 行内item间距 默认rw_itemSpacing = 10.0f */
    var rw_itemSpacing:CGFloat! {get set}
    /* 最大显示宽度
    默认 rw_safeAreaLayoutMaxWidth = UIScreen.main.bounds.width   */
    var rw_safeAreaLayoutMaxWidth:CGFloat! {get set}
    /* 🐱 当前宽宽显示的样式 默认 rw_fullSafeAreaStyle = .MaxWidth */
    var rw_fullSafeAreaStyle:RWAutoTagViewFullSafeAreaStyle! {get set}
    /* 🐱 排列样式 默认 rw_rangeStyle = .DynamicMulti */
    var rw_rangeStyle:RWAutoTagViewRangeStyle!{get set}
    /* 平分的标签数量 默认0 rw_equallyNumber = .DynamicFixedEquallyMulti 值大于0  */
    var rw_equallyNumber:NSInteger! {get}
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



