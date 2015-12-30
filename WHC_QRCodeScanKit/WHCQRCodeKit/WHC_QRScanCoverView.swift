//
//  WHC_QRScanCoverView.swift
//  WHC_QRCodeScanKit
//
//  Created by 吴海超 on 15/12/29.
//  Copyright © 2015年 吴海超. All rights reserved.
//

import UIKit

class WHC_QRScanCoverView: UIView {

    private let  kLineWidth: CGFloat = 5
    private let  kLineColor = UIColor.greenColor()
    private let  kLineLenght: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        /// setting draw
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, kLineWidth)
        CGContextSetStrokeColorWithColor(context, kLineColor.CGColor)
        CGContextSetLineJoin(context, .Round)
        CGContextSetLineCap(context, .Round)
        
        /// draw left top
        CGContextMoveToPoint(context, kLineLenght, 0)
        CGContextAddLineToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, 0, kLineLenght)
        
        /// draw right top
        CGContextMoveToPoint(context, CGRectGetWidth(rect) - kLineLenght, 0)
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0)
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), kLineLenght)
        
        /// draw letf bottom 
        CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) - kLineLenght)
        CGContextAddLineToPoint(context, 0, CGRectGetHeight(rect))
        CGContextAddLineToPoint(context, kLineLenght, CGRectGetHeight(rect))
        
        /// draw right bottom
        CGContextMoveToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) - kLineLenght)
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect))
        CGContextAddLineToPoint(context, CGRectGetWidth(rect) - kLineLenght, CGRectGetHeight(rect))
        
        CGContextDrawPath(context, .Stroke)
        UIGraphicsEndImageContext()
    }

}
