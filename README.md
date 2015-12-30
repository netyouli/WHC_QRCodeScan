# WHC_QRCodeScan

##  作者:吴海超
##  联系qq:712641411

##封装系统API和ZXingObjc 二维码扫描，相册图片二维码识别，二维码生成，开源swift版和oc版


###OC版使用例子（swift版请自行参考代码）
```objective-c
/// 开始扫描二维码
- (IBAction)clickStart:(id)sender {
    WHC_QRCodeVC * vc = [WHC_QRCodeVC new];
    /// 扫描二维码代理
    vc.delegate = self;
    /// 生成二维码图片地址
    vc.myQRCodeUrl = @"https://github.com/netyouli?tab=repositories";
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - WHC_QRCodeVCDelegate
/// 扫描二维码回调
- (void)WHCQRCodeVCScanCallBack:(NSString *)value isQRCode:(BOOL)isQRCode {
    if (isQRCode) {
        QRCodeWebVC * vc = [QRCodeWebVC new];
        vc.value = value;
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        [[[UIAlertView alloc] initWithTitle:value
                                    message:nil
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil,
                                    nil] show];
    }
}

/// 生成二维码图片回调
- (void)WHCQRCodeVCBecomeQRCodeImage:(UIImage *)image {
    MyQRCodeVC * vc = [MyQRCodeVC new];
    vc.myQRCodeImage = image;
    [self presentViewController:vc animated:YES completion:nil];
}

```
##运行效果
![image](https://github.com/netyouli/WHC_QRCodeScan/blob/master/qrcode.png)

