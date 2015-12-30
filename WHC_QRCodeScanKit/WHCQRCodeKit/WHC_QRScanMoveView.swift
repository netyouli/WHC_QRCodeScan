//
//  WHC_QRScanMoveView.swift
//  WHC_QRCodeScanKit
//
//  Created by 吴海超 on 15/12/29.
//  Copyright © 2015年 吴海超. All rights reserved.
//

import UIKit

class WHC_QRScanMoveView: UIView {
    
    private let kStartColor = UIColor(red: 63.0 / 255, green: 184.0 / 255, blue: 68.0 / 255, alpha: 0.2).CGColor
    private let kMidColor = UIColor(red: 63.0 / 255, green: 184.0 / 255, blue: 68.0 / 255, alpha: 0.7).CGColor
    private let kEndColor = UIColor(red: 63.0 / 255, green: 184.0 / 255, blue: 68.0 / 255, alpha: 0.2).CGColor
    private let kComponentsCount = 4
    internal static let kHeight: CGFloat = 20
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
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [kStartColor,kMidColor,kEndColor]
        let pointer = UnsafeMutablePointer<CGFloat>.alloc(kComponentsCount * colors.count)
        memset(pointer, 0x00, kComponentsCount * colors.count)
        for i in 0...colors.count - 1 {
            let colorRef = colors[i]
            let components = CGColorGetComponents(colorRef)
            for j in 0...kComponentsCount - 1 {
                pointer[i * kComponentsCount + j] = components[j]
            }
        }
        let locations = UnsafeMutablePointer<CGFloat>.alloc(3)
        locations[0] = 0
        locations[1] = 0.5
        locations[2] = 1
        let gradient = CGGradientCreateWithColorComponents(colorSpace, pointer, locations, 3)
        CGContextDrawLinearGradient(context,
                                    gradient,
                                    CGPointMake(0, 0),
                                    CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)),
                                    CGGradientDrawingOptions.DrawsAfterEndLocation)
        free(locations)
        free(pointer)
        UIGraphicsEndImageContext()
    }


}
