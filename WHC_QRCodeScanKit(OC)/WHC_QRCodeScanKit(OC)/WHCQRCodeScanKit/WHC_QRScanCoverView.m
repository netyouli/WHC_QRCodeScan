//
//  WHC_QRScanCoverView.m
//  WHC_QRCodeScanKit(OC)
//
//  Created by 吴海超 on 15/12/29.
//  Copyright © 2015年 吴海超. All rights reserved.
//

#import "WHC_QRScanCoverView.h"

#define kLineWidth (5)
#define kLineColor ([UIColor greenColor])
#define kLineLenght (15)

@implementation WHC_QRScanCoverView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    /// setting draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetStrokeColorWithColor(context, kLineColor.CGColor);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    /// draw left top
    CGContextMoveToPoint(context, kLineLenght, 0);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, kLineLenght);
    
    /// draw right top
    CGContextMoveToPoint(context, CGRectGetWidth(rect) - kLineLenght, 0);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), kLineLenght);
    
    /// draw letf bottom
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) - kLineLenght);
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(rect));
    CGContextAddLineToPoint(context, kLineLenght, CGRectGetHeight(rect));
    
    /// draw right bottom
    CGContextMoveToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) - kLineLenght);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - kLineLenght, CGRectGetHeight(rect));
    
    CGContextDrawPath(context, kCGPathStroke);
    UIGraphicsEndImageContext();
}

@end
