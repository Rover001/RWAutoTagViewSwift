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
    
    private var __rw_autoTagButtonStyle:RWAutoTagButtonStyle = .Text
    open var rw_autoTagButtonStyle: RWAutoTagButtonStyle! {
        get {return __rw_autoTagButtonStyle}
        set {
            if __rw_autoTagButtonStyle != newValue {
                __rw_autoTagButtonStyle = newValue
                if __rw_autoTagButtonStyle == .Image {
                    self.rw_imageStyle = .Center
                }
                self.initAutoButtonSubViews()
                self.setNeedsLayout()
            }
        }
    }
    
    private var __rw_imageStyle:RWAutoTagButtonImageStyle = .None
    open var rw_imageStyle: RWAutoTagButtonImageStyle! {
        get {return __rw_imageStyle}
        set {
            if __rw_imageStyle != newValue {
                __rw_imageStyle = newValue
                self.initAutoButtonSubViews()
                self.setNeedsLayout()
            }
        }
    }
    
    private var __rw_safeAreaLayoutMaxWidth:CGFloat = UIScreen.main.bounds.width
    open var rw_safeAreaLayoutMaxWidth: CGFloat! {
        get {return __rw_safeAreaLayoutMaxWidth}
        set {
            if (__rw_safeAreaLayoutMaxWidth != newValue) {
                __rw_safeAreaLayoutMaxWidth = newValue
                self.setNeedsLayout()
            }
        }
    }
    
    private var __rw_itemSpacing:CGFloat = CGFloat.zero
    open var rw_itemSpacing:CGFloat! {
        get {return __rw_itemSpacing}
        set {
            if (__rw_itemSpacing != newValue) {
                __rw_itemSpacing = newValue
                self.setNeedsLayout()
            }
        }
    }
    
    private var __rw_isDynamicFixed:Bool = false
    public var rw_isDynamicFixed: Bool! {
        get {return __rw_isDynamicFixed}
        set {
            if  __rw_isDynamicFixed != newValue {
                __rw_isDynamicFixed = newValue
            }
        }
    }
    
    private var __rw_dynamicFixedSize:CGSize = CGSize.zero
    open var rw_dynamicFixedSize: CGSize! {
        get {return __rw_dynamicFixedSize}
        set {
            if  __rw_dynamicFixedSize != newValue {
                __rw_dynamicFixedSize = newValue
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
//        self.titleLabel?.backgroundColor = UIColor.blue
//        self.imageView?.backgroundColor = UIColor.red
        
    }
    
    private func initAutoButtonSubViews() {
        switch __rw_autoTagButtonStyle {
        case .Text:break
        case .Image:
            self.setImage(rw_autotagImage, for: .normal)
            break
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
        switch __rw_autoTagButtonStyle {
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
        rw_size = newSize;
         return newSize
    }
    
    @discardableResult
    private func reloadAutoButtonSzie_Text() -> CGSize {
        /*  计算纯文字按钮 大小   */
        let horizontal:CGFloat! = rw_insetLeft + rw_insetRight
        let label_horizontal:CGFloat! = rw_textInsetLeft + rw_textInsetRight
        let vertical:CGFloat = rw_insetTop + rw_insetBottom;
        let label_vertical:CGFloat = rw_textInsetTop + rw_textInsetBottom;
        
        var intrinsicHeight:CGFloat! = vertical
        var intrinsicWidth:CGFloat! = horizontal
        
        intrinsicHeight += rw_textMaxHeight
        if self.rw_isDynamicFixed {
            intrinsicWidth = self.rw_dynamicFixedSize.width
            if self.rw_dynamicFixedSize.height != UITableView.automaticDimension {
                intrinsicHeight = self.rw_dynamicFixedSize.height
            }
        } else {
            intrinsicWidth += rw_textMaxWidth
        }
         intrinsicWidth = reloadSafeAreaWidth(safeAreaWidth: intrinsicWidth)
        
        var label_X:CGFloat!  = rw_insetLeft + rw_textInsetLeft
        var label_Y:CGFloat!  = rw_insetTop + rw_textInsetTop
        
        var label_Width:CGFloat! = rw_textWidth
        let label_Height:CGFloat! = rw_textHeight
           
       if (intrinsicWidth >= self.rw_safeAreaLayoutMaxWidth) {
           label_Width = intrinsicWidth - horizontal - label_horizontal;
       }
       
       if (self.rw_isDynamicFixed) {
           if (label_Width > self.rw_dynamicFixedSize.width) {
               label_Width = self.rw_dynamicFixedSize.width - horizontal - label_horizontal;
           }
           label_X = (intrinsicWidth - label_Width)/2;
        if self.rw_dynamicFixedSize.height != UITableView.automaticDimension {
            let new_label_height:CGFloat = intrinsicHeight - vertical - label_vertical
            if (new_label_height > label_Height) {
                label_Y += (new_label_height - label_Height)/2;
            }
        }
       }
           
        self.titleLabel!.frame = CGRect.init(x: label_X, y: label_Y, width: label_Width, height: label_Height)
        self.imageView!.frame = CGRect.init()
           
        return CGSize.init(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    @discardableResult
    private func reloadAutoButtonSize_Image() -> CGSize {
        /*  计算纯图片按钮 大小   */
        let horizontal:CGFloat = rw_insetLeft + rw_insetRight
        let image_horizontal:CGFloat = rw_imageInsetLeft + rw_imageInsetRight
        
        let vertical = rw_insetTop + rw_insetBottom
        let image_vertical = rw_imageInsetTop + rw_imageInsetBottom
        
        var intrinsicHeight:CGFloat = vertical
        var intrinsicWidth:CGFloat = horizontal
        
        intrinsicHeight +=  rw_imageMaxHeight
        if (self.rw_isDynamicFixed) {
            intrinsicWidth = self.rw_dynamicFixedSize.width;
            if self.rw_dynamicFixedSize.height != UITableView.automaticDimension {
                intrinsicHeight = self.rw_dynamicFixedSize.height;
            }
        } else {
            intrinsicWidth += rw_imageMaxWidth
        }
            
        intrinsicWidth = reloadSafeAreaWidth(safeAreaWidth: intrinsicWidth)
        
        
        let image_X:CGFloat = rw_insetLeft + rw_imageInsetLeft
        let image_Y:CGFloat = rw_insetTop + rw_imageInsetTop
        var image_Width:CGFloat = rw_imageWidth
        var image_Height:CGFloat = rw_imageHeight
        let image_AspectRatio:CGFloat = image_Width/image_Height
        
//        if (intrinsicWidth >= self.rw_safeAreaLayoutMaxWidth) {
//               image_Width = intrinsicWidth - horizontal - image_horizontal;
//           }
        
        if (self.rw_isDynamicFixed) {
            image_Width = intrinsicWidth - horizontal - image_horizontal
            if self.rw_dynamicFixedSize.height != UITableView.automaticDimension {
                image_Height = self.rw_dynamicFixedSize.height - vertical - image_vertical
            }
        } else {
            if (image_Width + horizontal + image_horizontal >= intrinsicWidth) {
                image_Width = intrinsicWidth - horizontal - image_horizontal;
                image_Height = image_Width/image_AspectRatio;
            }
        }
        
        self.imageView?.frame = CGRect.init(x: image_X, y: image_Y, width: image_Width, height: image_Height)
        self.titleLabel?.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        return CGSize.init(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    @discardableResult
    private func reloadAutoButtonSzie_Mingle() -> CGSize {
        /*  计算画图文混合按钮 大小   */
        
        let horizontal:CGFloat = rw_insetLeft + rw_insetRight
        let image_horizontal:CGFloat = rw_imageInsetLeft + rw_imageInsetRight
        let label_horizontal:CGFloat = rw_textInsetLeft + rw_textInsetRight
        let vertical:CGFloat = rw_insetTop + rw_insetBottom
        let image_vertical:CGFloat = rw_imageInsetTop + rw_imageInsetBottom
        
        let rw_itemSpacing:CGFloat = self.rw_itemSpacing
        var intrinsicHeight:CGFloat = vertical
        var intrinsicWidth:CGFloat = horizontal
        
        var image_X:CGFloat = CGFloat.zero
        var image_Y:CGFloat = CGFloat.zero
        var image_Width:CGFloat = rw_imageWidth
        var image_Height:CGFloat = rw_imageHeight
        let image_AspectRatio:CGFloat = image_Width/image_Height
        
        var label_X:CGFloat = CGFloat.zero
        var label_Y:CGFloat = CGFloat.zero
        var label_Width:CGFloat = rw_textWidth
        let label_Height:CGFloat = rw_textHeight
        
        let maxImageHeight:CGFloat = rw_imageMaxHeight
        var maxImageWidth:CGFloat = rw_imageMaxWidth
        let maxTextHeight:CGFloat = rw_textMaxHeight
        var maxTextWidth:CGFloat = rw_textMaxWidth
         
         if (self.rw_isDynamicFixed) {
             if (image_Width > self.rw_dynamicFixedSize.width) {
                 image_Width = self.rw_dynamicFixedSize.width - image_horizontal - horizontal;
             }

             if (label_Width > self.rw_dynamicFixedSize.width) {
                 label_Width = self.rw_dynamicFixedSize.width - label_horizontal - horizontal;
             }

             if (maxImageWidth > self.rw_dynamicFixedSize.width) {
                 maxImageWidth = self.rw_dynamicFixedSize.width - horizontal;
                 image_Width = maxImageWidth - image_horizontal;
             }

             if (maxTextWidth > self.rw_dynamicFixedSize.width) {
                 maxTextWidth = self.rw_dynamicFixedSize.width - horizontal;
                 label_Width = maxTextWidth - label_horizontal;
             }
         }
        
        switch (__rw_imageStyle) {
        case .Top,.Bottom: do {
                 intrinsicHeight += maxImageHeight + maxTextHeight + rw_itemSpacing
                 
                 if (self.rw_isDynamicFixed) {
                    intrinsicWidth = self.rw_dynamicFixedSize.width
                    if self.rw_dynamicFixedSize.height != UITableView.automaticDimension {
                        intrinsicHeight = self.rw_dynamicFixedSize.height;
                    }
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
                 
                if (__rw_imageStyle == .Top) {
                    /* 🐱 图片在上边 */
                     image_Y = rw_insetTop + rw_imageInsetTop
                     label_Y = image_Y + image_Height +  rw_imageInsetBottom + rw_itemSpacing + rw_textInsetTop
                     label_Width = intrinsicWidth
                    
                     if (intrinsicWidth < (max(maxTextWidth, maxImageWidth) + horizontal) ) {
                         if (maxTextWidth > maxImageWidth) {
                             label_Width = intrinsicWidth - horizontal - label_horizontal
                         }
                    }
                    
                    if self.rw_isDynamicFixed {
                        label_Width = max(intrinsicWidth - horizontal - label_horizontal, 0.0)
                    }
                     
                } else if (__rw_imageStyle == .Bottom) {
                     
                     label_Y = rw_insetTop + rw_textInsetTop
                     image_Y = label_Y + label_Height + rw_textInsetBottom + rw_itemSpacing + rw_imageInsetTop
                     label_Width = intrinsicWidth
                     if (intrinsicWidth < ( max(maxTextWidth, maxImageWidth) + horizontal) ) {
                         if (maxTextWidth > maxImageWidth) {
                             label_Width = intrinsicWidth - horizontal - label_horizontal
                         }
                     }
                    if (self.rw_isDynamicFixed) {
                        label_Width = max(intrinsicWidth - horizontal - label_horizontal, 0.0)
                    }
                 }
             }
                 break;
                 
        case .Left,.Right: do {
                 
                 intrinsicHeight += max(maxImageHeight, maxTextHeight)
                 if (self.rw_isDynamicFixed) {
                    intrinsicWidth = self.rw_dynamicFixedSize.width
                    if self.rw_dynamicFixedSize.height != UITableView.automaticDimension {
                        intrinsicHeight = self.rw_dynamicFixedSize.height;
                    }
                 } else {
                     intrinsicWidth += min(self.rw_safeAreaLayoutMaxWidth - horizontal,maxImageWidth + maxTextWidth + rw_itemSpacing)
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
                 
                 
            if (__rw_imageStyle == .Left) {
                 image_X = rw_insetLeft + rw_imageInsetLeft
                 label_X = image_X + image_Width + rw_itemSpacing + rw_imageInsetRight + rw_textInsetLeft
                 
                 if (intrinsicWidth <= (label_Width + label_X + rw_insetRight + rw_textInsetRight)) {
                     label_Width = intrinsicWidth - label_X - rw_insetRight -  rw_textInsetRight
                    }
                 
                 if (self.rw_isDynamicFixed) {
                    /*  固定宽 动态高  */
                     image_X = ((self.rw_dynamicFixedSize.width - horizontal) - (image_Width + label_Width) - rw_itemSpacing)/2
                     label_X = image_X + image_Width + rw_itemSpacing + image_horizontal;
                     if (intrinsicWidth <= (maxImageWidth + maxTextWidth + horizontal + rw_itemSpacing)) {
                         image_X = rw_insetLeft + rw_imageInsetLeft
                         if (maxImageWidth >= (intrinsicWidth - horizontal)) {
                             image_X = (intrinsicWidth - image_Width)/2
                         }
                         label_X = image_X + image_Width + rw_itemSpacing + rw_imageInsetRight + rw_textInsetLeft
                         label_Width = intrinsicWidth - label_X - rw_insetRight - rw_textInsetRight
                         if (label_Width < 0) {
                             label_Width = 0;
                         }
                    }
                    
                    /*  固定宽 固定高  */
                    if self.rw_dynamicFixedSize.height != UITableView.automaticDimension {
                        let new_fixedSize_height:CGFloat = intrinsicHeight - vertical - image_vertical
                        image_Height = new_fixedSize_height
                        image_Width = image_AspectRatio * image_Height
                        label_X = image_X + image_Width + image_horizontal + rw_itemSpacing
                        if new_fixedSize_height > label_Height {
                           label_Y = (new_fixedSize_height - label_Height)/2 + rw_textInsetTop
                        }
                        label_Width = max(intrinsicWidth - horizontal - image_horizontal - label_horizontal - image_Width - rw_itemSpacing, 0.0)
                    }
                    
                 }
            } else if (__rw_imageStyle == .Right) {
                     label_X = rw_insetLeft + rw_textInsetLeft
                     image_X =  intrinsicWidth - image_Width - rw_insetRight - rw_imageInsetRight
                     label_Width = image_X - label_X -  rw_itemSpacing - rw_textInsetRight - rw_imageInsetLeft
                     if (self.rw_isDynamicFixed) {
                        label_X = ((self.rw_dynamicFixedSize.width - horizontal) - (image_Width + label_Width) - rw_itemSpacing)/2
                        image_X = label_X + label_Width + rw_itemSpacing
                         if (intrinsicWidth <= (maxImageWidth + maxTextWidth + rw_itemSpacing + horizontal) ) {
                             image_X =  intrinsicWidth - image_Width - rw_insetRight - rw_imageInsetRight
                             if (maxImageWidth >= (intrinsicWidth - horizontal)) {
                                 image_X  = (intrinsicWidth - image_Width)/2
                             }
                             label_X = rw_insetLeft + rw_textInsetLeft
                             label_Width = max(image_X - label_X -  rw_itemSpacing - rw_textInsetRight - rw_imageInsetLeft,0)
                         }
                        
                        /*  固定宽 固定高  */
                        if self.rw_dynamicFixedSize.height != UITableView.automaticDimension {
                            let new_fixedSize_height:CGFloat = intrinsicHeight - vertical - image_vertical
                            image_Height = new_fixedSize_height
                            image_Width = image_AspectRatio * image_Height
                            if (new_fixedSize_height > label_Height) {
                               label_Y = (new_fixedSize_height - label_Height)/2 + rw_textInsetTop
                            }
                            label_Width = max(intrinsicWidth - horizontal - image_horizontal - label_horizontal - image_Width - rw_itemSpacing, 0.0);
                            image_X = intrinsicWidth - image_Width - rw_insetRight - rw_imageInsetRight
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
         if (self.rw_isDynamicFixed) {
            self.titleLabel?.textAlignment = .center
            if self.rw_dynamicFixedSize.height != UITableView.automaticDimension {
                intrinsicHeight = self.rw_dynamicFixedSize.height;
            }
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
        if safeAreaWidth >= self.rw_safeAreaLayoutMaxWidth {
            newSafeAreaWidth = self.rw_safeAreaLayoutMaxWidth
        }
        return newSafeAreaWidth
    }
    
}


protocol RWAutoTagButtonProtocol {
    /* 🐱 按钮样式 默认 autoButtonStyle = .Text */
    var rw_autoTagButtonStyle:RWAutoTagButtonStyle! {get set}
    
    /* 🐱 图片的位置样式 默认.None
      按钮样式为.Image的时候 图片位置默认为:.Center 修改图片的位置样式也是无效的
      按钮样式为.Mingle的时候 图片位置默认为:.Left 自动计算图片位置但不包括.Center
    */
    var rw_imageStyle:RWAutoTagButtonImageStyle! {get set}
    
    /* 最大显示宽度
    默认 safeAreaLayoutMaxWidth = UIScreen.main.bounds.width   */
    var rw_safeAreaLayoutMaxWidth:CGFloat! {get set}
    
    /* 行内item间距 默认lineitemSpacing = 0.0 */
    var rw_itemSpacing:CGFloat! {get set}
    
    /* 🐱 是否是动态固定宽度 默认false */
    var rw_isDynamicFixed:Bool! {get set}
    
    /* 🐱 固定宽度值 默认CGSizeZero */
    var rw_dynamicFixedSize:CGSize! {get set}
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
