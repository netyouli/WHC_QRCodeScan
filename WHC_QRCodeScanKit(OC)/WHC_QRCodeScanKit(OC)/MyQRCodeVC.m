//
//  MyQRCodeVC.m
//  WHC_QRCodeScanKit(OC)
//
//  Created by 吴海超 on 15/12/30.
//  Copyright © 2015年 吴海超. All rights reserved.
//

#import "MyQRCodeVC.h"

@interface MyQRCodeVC ()
@property (nonatomic ,strong)IBOutlet UIImageView * myQRCodeImageView;
@end

@implementation MyQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIImageWriteToSavedPhotosAlbum(_myQRCodeImage, nil, nil, nil);
    _myQRCodeImageView.image = _myQRCodeImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
