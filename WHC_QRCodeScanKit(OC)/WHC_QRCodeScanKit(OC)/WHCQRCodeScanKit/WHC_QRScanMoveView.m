//
//  WHC_QRScanMoveView.m
//  WHC_QRCodeScanKit(OC)
//
//  Created by 吴海超 on 15/12/29.
//  Copyright © 2015年 吴海超. All rights reserved.
//

#import "WHC_QRScanMoveView.h"

#define  kStartColor  ([UIColor colorWithRed:63.0 / 255 green:184.0 / 255 blue:68.0 / 255 alpha:0.1])
#define kMidColor  ([UIColor colorWithRed:63.0 / 255 green:184.0 / 255 blue:68.0 / 255 alpha:0.7])
#define  kEndColor  ([UIColor colorWithRed:63.0 / 255 green:184.0 / 255 blue:68.0 / 255 alpha:0.1])
#define  kComponentsCount (4)

@interface WHC_QRScanMoveView () {
    
}

@end

@implementation WHC_QRScanMoveView

- (instancetype)init {
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

+ (CGFloat)height {
    return 20;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray * colors = @[kStartColor,kMidColor,kEndColor];
    CGFloat pointer[kComponentsCount * colors.count];
    memset(pointer, 0x00, kComponentsCount * colors.count);
    for (int i = 0; i < colors.count; i++){
        UIColor * color = colors[i];
        CGColorRef colorRef = color.CGColor;
        const CGFloat * components = CGColorGetComponents(colorRef);
        for (int j = 0; j < kComponentsCount; j++) {
            pointer[i * kComponentsCount + j] = components[j];
        }
    }
    CGFloat locations[3] = {0,0.5,1};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, pointer, locations, 3);
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(0, 0),
                                CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)),
                                kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
}


@end
