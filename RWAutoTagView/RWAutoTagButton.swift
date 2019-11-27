//
//  RWAutoTagButton.swift
//  RWAutoTagViewSwift
//
//  Created by RoverWord on 2019/11/21.
//  Copyright © 2019 RoverWord. All rights reserved.
//

import UIKit


/* 🐱 按钮样式 */
public enum RWAutoTagButtonStyle:NSInteger {
    /*  默认 纯文字  */
    case Text = 0
    /*  纯图片  */
    case Image = 1
    /*  图文混合  */
    case Mingle = 2
    /*  自定制 暂未实现  */
    case Custom = 3
}

/* 🐱 图片的位置样式
 按钮样式为:.Image或者.Mingle有效
 */
public enum RWAutoTagButtonImageStyle:NSInteger {
    /*  默认   */
    case None = 0
    /*  图片在上面  */
    case Top = 1
    /*  图片在左边  */
    case Left = 2
    /*  图片在底部  */
    case Bottom = 3
    /*  图片在右边  */
    case Right = 4
    /*  图片居中  按钮样式为.Image的时候 有效 */
    case Center = 5
}

public class RWAutoTagButton: UIButton,RWAutoTagButtonProtocol {
    
    private var __autoTagButtonStyle:RWAutoTagButtonStyle = .Text
    open var autoTagButtonStyle: RWAutoTagButtonStyle! {
        get {return __autoTagButtonStyle}
        set {
            if __autoTagButtonStyle != newValue {
                __autoTagButtonStyle = newValue
                if  __autoTagButtonStyle == .Image ||
                    __autoTagButtonStyle == .Mingle {
                    self.imageStyle = .Left
                    if __autoTagButtonStyle == .Image {
                        self.imageStyle = .Center
                    }
                }
                self.initAutoButtonSubViews()
                self.setNeedsLayout()
            }
        }
    }
    
    private var __imageStyle:RWAutoTagButtonImageStyle = .None
    open var imageStyle: RWAutoTagButtonImageStyle! {
        get {return __imageStyle}
        set {
            if __imageStyle != newValue {
                __imageStyle = newValue
                if  __autoTagButtonStyle == .Image ||
                    __autoTagButtonStyle == .Mingle {
                    self.initAutoButtonSubViews()
                    self.setNeedsLayout()
                }
            }
        }
    }
    
    private var __safeAreaLayoutMaxWidth:CGFloat = UIScreen.main.bounds.width
    open var safeAreaLayoutMaxWidth: CGFloat! {
        get {return __safeAreaLayoutMaxWidth}
        set {
            if (__safeAreaLayoutMaxWidth != newValue) {
                __safeAreaLayoutMaxWidth = newValue
                self.setNeedsLayout()
            }
        }
    }
    
    private var __lineitemSpacing:CGFloat = CGFloat.zero
    open var lineitemSpacing:CGFloat! {
        get {return __lineitemSpacing}
        set {
            if (__lineitemSpacing != newValue) {
                __lineitemSpacing = newValue
                self.setNeedsLayout()
            }
        }
    }
    
    private var __isDynamicFixed:Bool = false
    public var isDynamicFixed: Bool! {
        get {return __isDynamicFixed}
        set {
            if  __isDynamicFixed != newValue {
                __isDynamicFixed = newValue
            }
        }
    }
    
    private var __dynamicFixedSize:CGSize = CGSize.zero
    open var dynamicFixedSize: CGSize! {
        get {return __dynamicFixedSize}
        set {
            if  __dynamicFixedSize != newValue {
                __dynamicFixedSize = newValue
            }
        }
    }
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initAttribute()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initAttribute()
    }
    
    private func initAttribute() {
        print("initAttribute")
        self.titleLabel?.backgroundColor = UIColor.blue
        self.imageView?.backgroundColor = UIColor.red
        
    }
    
    private func initAutoButtonSubViews() {
        switch __autoTagButtonStyle {
        case .Text:break
        case .Image:break
        case .Mingle:
            self.setImage(rw_autotagImage, for: .normal)
            break
        case .Custom:break
        }
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
        switch __autoTagButtonStyle {
        case .Text:
            newSize = reloadAutoButtonSzie_Text()
            break
        case .Image:
            newSize = reloadAutoButtonSize_Image()
            break
        case .Mingle:
            newSize = reloadAutoButtonSzie_Mingle()
            break
        case .Custom:
            newSize = reloadAutoButtonSize_Custom()
            break
        }
         return newSize
    }
    
    @discardableResult
    private func reloadAutoButtonSzie_Text() -> CGSize {
        /*  计算纯文字按钮 大小   */
        let lineInsets:CGFloat! = rw_insetLeft + rw_insetRight
        let label_lineInsets:CGFloat! = rw_textInsetLeft + rw_textInsetRight
        
        var intrinsicHeight:CGFloat! = rw_insetTop + rw_insetBottom
        var intrinsicWidth:CGFloat! = lineInsets
        
        intrinsicHeight += rw_textMaxHeight
        if self.isDynamicFixed {
            intrinsicWidth = self.dynamicFixedSize.width
        } else {
            intrinsicWidth += rw_textMaxWidth
        }
         intrinsicWidth = reloadSafeAreaWidth(safeAreaWidth: intrinsicWidth)
        
        var label_X:CGFloat!  = rw_insetLeft + rw_textInsetLeft
        let label_Y:CGFloat!  = rw_insetTop + rw_textInsetTop
        
        var label_Width:CGFloat! = rw_textWidth
        let label_Height:CGFloat! = rw_textHeight
           
       if (intrinsicWidth >= self.safeAreaLayoutMaxWidth) {
           label_Width = intrinsicWidth - lineInsets - label_lineInsets;
       }
       
       if (self.isDynamicFixed) {
           if (label_Width > self.dynamicFixedSize.width) {
               label_Width = self.dynamicFixedSize.width - lineInsets - label_lineInsets;
           }
           label_X = (intrinsicWidth - label_Width)/2;
       }
           
        self.titleLabel!.frame = CGRect.init(x: label_X, y: label_Y, width: label_Width, height: label_Height)
        
        self.imageView!.frame = CGRect.init()
           
        return CGSize.init(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    
    
    
    
    @discardableResult
    private func reloadAutoButtonSize_Image() -> CGSize {
        /*  计算纯图片按钮 大小   */
        let lineInsets:CGFloat = rw_insetLeft + rw_insetRight
        let image_lineInsets:CGFloat = rw_imageInsetLeft + rw_imageInsetRight
        
        var intrinsicHeight:CGFloat = rw_insetTop + rw_insetBottom
        var intrinsicWidth:CGFloat = lineInsets
        
        intrinsicHeight +=  rw_imageMaxHeight
        if (self.isDynamicFixed) {
            intrinsicWidth = self.dynamicFixedSize.width;
        } else {
            intrinsicWidth += rw_imageMaxWidth
        }
            
        intrinsicWidth = reloadSafeAreaWidth(safeAreaWidth: intrinsicWidth)
        
        
        var image_X:CGFloat = rw_insetLeft + rw_imageInsetLeft
        let image_Y:CGFloat = rw_insetTop + rw_imageInsetTop
        var image_Width:CGFloat = rw_imageWidth
        let image_Height:CGFloat = rw_imageHeight
        
        if (intrinsicWidth >= self.safeAreaLayoutMaxWidth) {
               image_Width = intrinsicWidth - lineInsets - image_lineInsets;
           }
        
        if (self.isDynamicFixed) {
            if (image_Width > self.dynamicFixedSize.width) {
                image_Width = self.dynamicFixedSize.width;
            }
            image_X = (intrinsicWidth - image_Width)/2;
        }
        
        self.imageView?.frame = CGRect.init(x: image_X, y: image_Y, width: image_Width, height: image_Height)
        self.titleLabel?.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        return CGSize.init(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    
    @discardableResult
    private func reloadAutoButtonSzie_Mingle() -> CGSize {
        /*  计算画图文混合按钮 大小   */
        let lineitemSpacing:CGFloat = self.lineitemSpacing
        var intrinsicHeight:CGFloat = rw_insetTop + rw_insetBottom
        var intrinsicWidth:CGFloat = rw_insetLeft + rw_insetRight
        
        var image_X:CGFloat = CGFloat.zero
        var image_Y:CGFloat = CGFloat.zero
        var image_Width:CGFloat = rw_imageWidth
        let image_Height:CGFloat = rw_imageHeight
        
        var label_X:CGFloat = CGFloat.zero
        var label_Y:CGFloat = CGFloat.zero
        var label_Width:CGFloat = rw_textWidth
        let label_Height:CGFloat = rw_textHeight
        
         
        let lineInsets:CGFloat = rw_insetLeft + rw_insetRight
        let image_lineInsets:CGFloat = rw_imageInsetLeft + rw_imageInsetRight
        let label_lineInsets:CGFloat = rw_textInsetLeft + rw_textInsetRight
        
        let maxImageHeight:CGFloat = rw_imageMaxHeight
        var maxImageWidth:CGFloat = rw_imageMaxWidth
        let maxTextHeight:CGFloat = rw_textMaxHeight
        var maxTextWidth:CGFloat = rw_textMaxWidth
         
         if (self.isDynamicFixed) {
             if (image_Width > self.dynamicFixedSize.width) {
                 image_Width = self.dynamicFixedSize.width - image_lineInsets - lineInsets;
             }

             if (label_Width > self.dynamicFixedSize.width) {
                 label_Width = self.dynamicFixedSize.width - label_lineInsets - lineInsets;
             }

             if (maxImageWidth > self.dynamicFixedSize.width) {
                 maxImageWidth = self.dynamicFixedSize.width - lineInsets;
                 image_Width = maxImageWidth - image_lineInsets;
             }

             if (maxTextWidth > self.dynamicFixedSize.width) {
                 maxTextWidth = self.dynamicFixedSize.width - lineInsets;
                 label_Width = maxTextWidth - label_lineInsets;
             }
         }
        
        switch (__imageStyle) {
        case .Top,.Bottom: do {
                 intrinsicHeight += maxImageHeight + maxTextHeight + lineitemSpacing
                 
                 if (self.isDynamicFixed) {
                         intrinsicWidth = self.dynamicFixedSize.width
                    } else {
                        intrinsicWidth += max(maxImageWidth, maxTextWidth)
                    }
                 
                 intrinsicWidth = reloadSafeAreaWidth(safeAreaWidth: intrinsicWidth)
                 
                 
                 label_X = (intrinsicWidth - label_Width)/2
                  if (maxTextWidth > maxImageWidth) {
                      label_X = rw_insetLeft + rw_textInsetLeft
                  }
                 
                  image_X = (intrinsicWidth - image_Width)/2
                  if (maxImageWidth > maxTextWidth) {
                      image_X = rw_insetLeft + rw_imageInsetLeft
                  }
                 
                if (__imageStyle == .Top) {
                    /* 🐱 图片在上边 */
                     image_Y = rw_insetTop + rw_imageInsetTop
                     label_Y = image_Y + image_Height +  rw_imageInsetBottom + lineitemSpacing + rw_textInsetTop
                     label_Width = intrinsicWidth
                    
                     if (intrinsicWidth < (max(maxTextWidth, maxImageWidth) + lineInsets) ) {
                         if (maxTextWidth > maxImageWidth) {
                             label_Width = intrinsicWidth - lineInsets - label_lineInsets
                         }
                    }
                     
                } else if (__imageStyle == .Bottom) {
                     
                     label_Y = rw_insetTop + rw_textInsetTop
                     image_Y = label_Y + label_Height + rw_textInsetBottom + lineitemSpacing + rw_imageInsetTop
                     label_Width = intrinsicWidth
                     if (intrinsicWidth < ( max(maxTextWidth, maxImageWidth) + lineInsets) ) {
                         if (maxTextWidth > maxImageWidth) {
                             label_Width = intrinsicWidth - lineInsets - label_lineInsets
                         }
                     }
                 }
             }
                 break;
                 
        case .Left,.Right: do {
                 
                 intrinsicHeight += max(maxImageHeight, maxTextHeight)
                 if (self.isDynamicFixed) {
                      intrinsicWidth = self.dynamicFixedSize.width;
                 } else {
                     intrinsicWidth += min(self.safeAreaLayoutMaxWidth - lineInsets,maxImageWidth + maxTextWidth + lineitemSpacing)
//                    MIN(self.safeAreaLayoutMaxWidth - lineInsets, maxImageWidth + maxTextWidth + lineitemSpacing)
                 }
                 
                 intrinsicWidth = reloadSafeAreaWidth(safeAreaWidth: intrinsicWidth)
                 
                 image_Y = (intrinsicHeight-image_Height)/2
                 if (maxImageHeight > maxTextHeight) {
                     image_Y = rw_insetTop + rw_imageInsetTop
                 }
                 
                 label_Y = (intrinsicHeight-label_Height)/2;
                if (maxTextHeight > maxImageHeight) {
                    label_Y = rw_insetTop + rw_textInsetTop
                }
                 
                 
            if (__imageStyle == .Left) {
                 image_X = rw_insetLeft + rw_imageInsetLeft
                 label_X = image_X + image_Width + lineitemSpacing + rw_imageInsetRight + rw_textInsetLeft
                 
                 if (intrinsicWidth <= (label_Width + label_X + rw_insetRight + rw_textInsetRight)) {
                     label_Width = intrinsicWidth - label_X - rw_insetRight -  rw_textInsetRight
                    }
                 
                 if (self.isDynamicFixed) {
                     image_X = ((self.dynamicFixedSize.width - lineInsets) - (image_Width + label_Width) - lineitemSpacing)/2
                     label_X = image_X + image_Width + lineitemSpacing + image_lineInsets;
                     if (intrinsicWidth <= (maxImageWidth + maxTextWidth + lineInsets + lineitemSpacing)) {
                         image_X = rw_insetLeft + rw_imageInsetLeft
                         if (maxImageWidth >= (intrinsicWidth - lineInsets)) {
                             image_X = (intrinsicWidth - image_Width)/2
                         }
                         label_X = image_X + image_Width + lineitemSpacing + rw_imageInsetRight + rw_textInsetLeft
                         label_Width = intrinsicWidth - label_X - rw_insetRight - rw_textInsetRight
                         if (label_Width < 0) {
                             label_Width = 0;
                         }
                    }
                 }
            } else if (__imageStyle == .Right) {
                     label_X = rw_insetLeft + rw_textInsetLeft
                     image_X =  intrinsicWidth - image_Width - rw_insetRight - rw_imageInsetRight
                     label_Width = image_X - label_X -  lineitemSpacing - rw_textInsetRight - rw_imageInsetLeft
                     if (self.isDynamicFixed) {
                        label_X = ((self.dynamicFixedSize.width - lineInsets) - (image_Width + label_Width) - lineitemSpacing)/2
                        image_X = label_X + label_Width + lineitemSpacing
                         if (intrinsicWidth <= (maxImageWidth + maxTextWidth + lineitemSpacing + lineInsets) ) {
                             image_X =  intrinsicWidth - image_Width - rw_insetRight - rw_imageInsetRight
                             if (maxImageWidth >= (intrinsicWidth - lineInsets)) {
                                 image_X  = (intrinsicWidth - image_Width)/2
                             }
                             
                             label_X = rw_insetLeft + rw_textInsetLeft
                             label_Width = image_X - label_X -  lineitemSpacing - rw_textInsetRight - rw_imageInsetLeft
                             if (label_Width < 0) {
                                 label_Width = 0;
                             }
                         }
                    }
                 }
             }
                 break;
         
             default:
                 break;
         }
         
         self.imageView?.frame = CGRect.init(x: image_X, y: image_Y, width: image_Width, height: image_Height)
         self.titleLabel?.frame = CGRect.init(x: label_X, y: label_Y, width: label_Width, height: label_Height)
         if (self.isDynamicFixed) {
            self.titleLabel?.textAlignment = .center
         }
         
        return CGSize.init(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    
    
    
    @discardableResult
    private func reloadAutoButtonSize_Custom() -> CGSize {
        /*  计算自定义按钮 大小   */
//        self.rw_x = 100
        return CGSize.zero
    }
    
    
    @discardableResult
    private func reloadSafeAreaWidth(safeAreaWidth:CGFloat) -> CGFloat! {
        var newSafeAreaWidth = safeAreaWidth
        if safeAreaWidth >= self.safeAreaLayoutMaxWidth {
            newSafeAreaWidth = self.safeAreaLayoutMaxWidth
        }
        return newSafeAreaWidth
    }
    
}


protocol RWAutoTagButtonProtocol {
    /* 🐱 按钮样式 默认 autoButtonStyle = .Text */
    var autoTagButtonStyle:RWAutoTagButtonStyle! {get set}
    
    /* 🐱 图片的位置样式 默认.None
      按钮样式为.Image的时候 图片位置默认为:.Center 修改图片的位置样式也是无效的
      按钮样式为.Mingle的时候 图片位置默认为:.Left 自动计算图片位置但不包括.Center
    */
    var imageStyle:RWAutoTagButtonImageStyle! {get set}
    
    /* 最大显示宽度
    默认 safeAreaLayoutMaxWidth = UIScreen.main.bounds.width   */
    var safeAreaLayoutMaxWidth:CGFloat! {get set}
    
    /* 行内item间距 默认lineitemSpacing = 0.0 */
    var lineitemSpacing:CGFloat! {get set}
    
    /* 🐱 是否是动态固定宽度 默认false */
    var isDynamicFixed:Bool! {get set}
    
    /* 🐱 固定宽度值 默认CGSizeZero */
    var dynamicFixedSize:CGSize! {get set}
}


extension RWAutoTagButton {
    private var rw_x:CGFloat {
        get {return self.frame.origin.x}
        set {
            var frame:CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    private var rw_y:CGFloat {
        get {return self.frame.origin.y}
        set {
            var frame:CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    private var rw_w:CGFloat {
        get {return self.frame.size.width}
        set {
            var frame:CGRect = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    private var rw_h:CGFloat {
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
    
    /*  UIEdgeInsets  */
    private var rw_insetTop: CGFloat! {
        get { return self.contentEdgeInsets.top}
    }
    private var rw_insetLeft: CGFloat! {
        get { return self.contentEdgeInsets.left}
    }
    private var rw_insetBottom: CGFloat! {
        get { return self.contentEdgeInsets.bottom}
    }
    private var rw_insetRight: CGFloat! {
        get { return self.contentEdgeInsets.right}
    }
    
    /*   UIImageView UIEdgeInsets CGSize  */
    
    private var rw_imageInsetTop: CGFloat! {
        get {return self.imageEdgeInsets.top}
    }
    private var rw_imageInsetLeft: CGFloat! {
        get {return self.imageEdgeInsets.left}
    }
    private var rw_imageInsetBottom: CGFloat! {
        get {return self.imageEdgeInsets.bottom}
    }
    private var rw_imageInsetRight: CGFloat! {
        get {return self.imageEdgeInsets.right}
    }
    
    private var rw_imageWidth: CGFloat! {
        get {return self.currentImage?.size.width}
    }
    private var rw_imageHeight: CGFloat! {
        get {return self.currentImage?.size.height}
    }
    private var rw_imageMaxWidth: CGFloat! {
        get {return rw_imageInsetLeft + rw_imageInsetRight + rw_imageWidth}
    }
    private var rw_imageMaxHeight: CGFloat! {
        get {return rw_imageInsetTop + rw_imageInsetBottom + rw_imageHeight}
    }
    
    /*  UILabel UIEdgeInsets CGSize  */
    
    private var rw_textInsetTop: CGFloat! {
        get {return self.titleEdgeInsets.top}
    }
    private var rw_textInsetLeft: CGFloat! {
        get {return self.titleEdgeInsets.left}
    }
    private var rw_textInsetBottom: CGFloat! {
        get {return self.titleEdgeInsets.bottom}
    }
    private var rw_textInsetRight: CGFloat! {
        get {return self.titleEdgeInsets.right}
    }
    
    private var rw_textWidth: CGFloat! {
        get {return self.titleLabel?.intrinsicContentSize.width}
    }
    private var rw_textHeight: CGFloat! {
        get {return self.titleLabel?.intrinsicContentSize.height}
    }
    private var rw_textMaxWidth: CGFloat! {
        get {return rw_textInsetLeft + rw_textInsetRight + rw_textWidth}
    }
    private var rw_textMaxHeight: CGFloat! {
        get {return rw_textInsetTop + rw_textInsetBottom + rw_textHeight}
    }
    
    
    private var rw_autoTagBundle:Bundle {
        let bundle:Bundle = Bundle.init(for: RWAutoTagButton.classForCoder())
        //Bundle.main.path(forResource: "RWAutoTag", ofType: "bundle") ?? "RWAutoTag"
        //bundle.path(forResource: "RWAutoTag", ofType: "bundle") ?? "RWAutoTag"
        return Bundle.init(path: bundle.path(forResource: "RWAutoTag", ofType: "bundle")!)!
    }
    
    private var rw_autotagImage: UIImage {
            if #available(iOS 13.0, *) {
                return   UIImage.init(named: "RWAutoTag", in: self.rw_autoTagBundle, with: .none)!
            } else {
    //            UIImage.init(contentsOfFile: self.rw_autoTagBundle.path(forResource: "RWAutoTag", ofType: "png")!)!.withRenderingMode(.alwaysTemplate)
                return UIImage.init(contentsOfFile: self.rw_autoTagBundle.path(forResource: "RWAutoTag", ofType: "png")!)!
            }
        }
}
