//
//  ViewController.m
//  WHC_QRCodeScanKit(OC)
//
//  Created by 吴海超 on 15/12/29.
//  Copyright © 2015年 吴海超. All rights reserved.
//

#import "ViewController.h"
#import "WHC_QRCodeVC.h"
#import "QRCodeWebVC.h"
#import "MyQRCodeVC.h"
@interface ViewController () <WHC_QRCodeVCDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickStart:(id)sender {
    WHC_QRCodeVC * vc = [WHC_QRCodeVC new];
    vc.delegate = self;
    vc.myQRCodeUrl = @"https://github.com/netyouli?tab=repositories";
    [self presentViewController:vc animated:YES completion:nil];
}

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

- (void)WHCQRCodeVCBecomeQRCodeImage:(UIImage *)image {
    MyQRCodeVC * vc = [MyQRCodeVC new];
    vc.myQRCodeImage = image;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
