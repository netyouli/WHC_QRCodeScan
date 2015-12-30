//
//  QRCodeWebVC.m
//  WHC_QRCodeScanKit(OC)
//
//  Created by 吴海超 on 15/12/29.
//  Copyright © 2015年 吴海超. All rights reserved.
//

#import "QRCodeWebVC.h"

@interface QRCodeWebVC ()
@property (nonatomic ,strong)IBOutlet UIWebView * webView;
@end

@implementation QRCodeWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURL * url = [NSURL URLWithString:_value];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

@end
