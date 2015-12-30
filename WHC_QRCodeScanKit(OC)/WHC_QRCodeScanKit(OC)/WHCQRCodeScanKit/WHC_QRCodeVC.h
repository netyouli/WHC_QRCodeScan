//
//  WHC_QRCodeVC.h
//  WHC_QRCodeScanKit(OC)
//
//  Created by 吴海超 on 15/12/29.
//  Copyright © 2015年 吴海超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingObjC.h"

@protocol WHC_QRCodeVCDelegate <NSObject>

- (void)WHCQRCodeVCScanCallBack:(NSString *)value isQRCode:(BOOL)isQRCode;
- (void)WHCQRCodeVCBecomeQRCodeImage:(UIImage *)image;

@end

@interface WHC_QRCodeVC : UIViewController
@property (nonatomic, weak)id<WHC_QRCodeVCDelegate> delegate;
@property (nonatomic, copy)NSString * myQRCodeUrl;


/**
 说明： 生成二维码图片
 @param url 二维码跳转连接
 @param size 二维码图片大小
 */
+ (UIImage *)becomeQRCodeImageWithQRUrl:(NSString *)url
                                   size:(CGSize)size;

/**
 说明： 通过图片识别二维码
 @param QRImage 带二维码的图片
 */
+ (ZXResult *)scanQRCodeImage:(UIImage *)QRImage ;
@end
