//
//  WHC_QRCodeVC.m
//  WHC_QRCodeScanKit(OC)
//
//  Created by 吴海超 on 15/12/29.
//  Copyright © 2015年 吴海超. All rights reserved.
//

#import "WHC_QRCodeVC.h"
#import "WHC_QRScanCoverView.h"
#import "WHC_QRScanMoveView.h"
#import "WHC_PictureListVC.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kCoverViewColor ([UIColor colorWithWhite:0.2 alpha:0.4])
#define kScanViewWidth (250)

@interface WHC_QRCodeVC () <ZXCaptureDelegate, WHC_ChoicePictureVCDelegate>{
    WHC_QRScanMoveView * _scanMoveView;
    ZXCapture *          _captureDevice;
    UIView    *          _scanView;
    BOOL                 _isInit;
    BOOL                 _hideStatus;
}

@end

@interface WHC_QRCodeVC ()

@end

@implementation WHC_QRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hideStatus = YES;
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = _hideStatus;
    }
    if (!_isInit) {
        _isInit = YES;
        [self initData];
        [self layoutUI];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _hideStatus = NO;
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = _hideStatus;
    }
}

- (BOOL)prefersStatusBarHidden {
    return _hideStatus;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_captureDevice.layer removeFromSuperlayer];
}

- (void)initData {
    _captureDevice = [[ZXCapture alloc]init];
    _captureDevice.camera = _captureDevice.back;
    _captureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
}

- (void)layoutUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationNone];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self.view.layer addSublayer:_captureDevice.layer];
    _captureDevice.layer.frame = [UIScreen mainScreen].bounds;
    _captureDevice.delegate = self;
    [self makeUILayout];
    [self applyOrientation];
    [_captureDevice start];

}

- (UIButton *)createButton:(CGRect)frame title:(NSString *)title action:(SEL)action {
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = frame;
    [cancelButton setTitle:title forState:UIControlStateNormal];
    [cancelButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    return cancelButton;
}

- (void)makeUILayout {
    
    CGFloat y = 20 + 50 + 30;
    CGFloat size = kScanViewWidth;
    CGFloat x = (kScreenWidth - size) / 2;
    _scanView = [[UIView alloc]initWithFrame:CGRectMake(x , y , size , size)];
    _scanView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scanView];
    
    /// add Cover layer
    
    WHC_QRScanCoverView * scanCoverView = [[WHC_QRScanCoverView alloc] initWithFrame:_scanView.bounds];
    [_scanView addSubview:scanCoverView];
    
    UIView * topCoverView = [[UIView alloc]initWithFrame:CGRectMake(0 ,
                                                                    0 ,
                                                                    kScreenWidth ,
                                                                    CGRectGetMinY(_scanView.frame))];
    topCoverView.backgroundColor = kCoverViewColor;
    [self.view addSubview:topCoverView];
    
    /// top three button
    x = 20, y = 20 ,size = 50;
    [self createButton:CGRectMake(x, y, size, size)
                 title:@"返回"
                action:@selector(clickBack:)];
    [self createButton:CGRectMake((kScreenWidth - size) / 2, y, size, size)
                 title:@"相册"
                action:@selector(clickPhoto:)];
    [self createButton:CGRectMake(kScreenWidth - size - x, y, size, size)
                 title:@"闪电"
                action:@selector(clickLightning:)];
    
    UIView * leftCoverView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMinY(_scanView.frame),
                                                                      (kScreenWidth - CGRectGetWidth(_scanView.frame)) / 2,
                                                                      CGRectGetHeight(_scanView.frame))];
    leftCoverView.backgroundColor = kCoverViewColor;
    [self.view addSubview:leftCoverView];
    
    UIView * rightCoverView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_scanView.frame) ,
                                                                       CGRectGetMinY(_scanView.frame),
                                                                       (kScreenWidth - CGRectGetWidth(_scanView.frame)) / 2 ,
                                                                       CGRectGetHeight(_scanView.frame))];
    rightCoverView.backgroundColor = kCoverViewColor;
    [self.view addSubview:rightCoverView];

    UIView * bottomCoverView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        CGRectGetMaxY(_scanView.frame),
                                                                        kScreenWidth,
                                                                        kScreenHeight - CGRectGetMaxY(_scanView.frame))];
    bottomCoverView.backgroundColor = kCoverViewColor;
    [self.view addSubview: bottomCoverView];
    
    y = CGRectGetMaxY(_scanView.frame) + 20;
    size = kScanViewWidth;
    x = (kScreenWidth - size) / 2;
    UILabel * promptLable = [[UILabel alloc]initWithFrame:CGRectMake(x , y , size , 20)];
    promptLable.text = @"将二维码或条形码放入扫描框内,即可自动扫描";
    promptLable.textAlignment = NSTextAlignmentCenter;
    promptLable.minimumScaleFactor = 0.2;
    promptLable.adjustsFontSizeToFitWidth = true;
    promptLable.textColor = [UIColor whiteColor];
    [self.view addSubview:promptLable];
    
    x = (kScreenWidth - size) / 2;
    size = kScanViewWidth;
    y = CGRectGetMaxY(promptLable.frame) + 10;
    UIButton * myQRCodeButton = [self createButton:CGRectMake(x, y, size, 40)
                                             title:@"我的二维码"
                                            action:@selector(clickMyQRCode:)];
    [myQRCodeButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    _scanMoveView = [[WHC_QRScanMoveView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         CGRectGetWidth(_scanView.bounds),
                                                                         [WHC_QRScanMoveView height])];
    [_scanView addSubview:_scanMoveView];
    [_scanMoveView sendSubviewToBack:scanCoverView];
    _scanView.clipsToBounds = YES;
    [self startScanAnimation];
}

- (void)startScanAnimation {
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
        _scanMoveView.frame = CGRectMake(0,
                                         CGRectGetHeight(_scanView.bounds),
                                         CGRectGetWidth(_scanView.bounds),
                                         [WHC_QRScanMoveView height]);
    } completion:^(BOOL finished) {
        _scanMoveView.frame = CGRectMake(0,
                                         -[WHC_QRScanMoveView height],
                                         CGRectGetWidth(_scanView.bounds),
                                         [WHC_QRScanMoveView height]);
        [self startScanAnimation];
    }];
}

#pragma mark - Private
- (void)applyOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
        case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    [self applyRectOfInterest:orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
    [_captureDevice setTransform:transform];
    [_captureDevice setRotation:scanRectRotation];
    _captureDevice.layer.frame = self.view.frame;
}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
    CGFloat scaleVideo, scaleVideoX, scaleVideoY;
    CGFloat videoSizeX, videoSizeY;
    CGRect transformedVideoRect = _scanView.frame;
    if([_captureDevice.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        videoSizeX = 1080;
        videoSizeY = 1920;
    } else {
        videoSizeX = 720;
        videoSizeY = 1280;
    }
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        scaleVideoX = self.view.frame.size.width / videoSizeX;
        scaleVideoY = self.view.frame.size.height / videoSizeY;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
        }
    } else {
        scaleVideoX = self.view.frame.size.width / videoSizeY;
        scaleVideoY = self.view.frame.size.height / videoSizeX;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
        }
    }
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
    _captureDevice.scanRect = CGRectApplyAffineTransform(transformedVideoRect, captureSizeTransform);
    
}

#pragma mark - action

- (void)openLightning:(BOOL)open {
    if ([_captureDevice hasTorch] && [_captureDevice hasBack]) {
        _captureDevice.torch = open;
    }
}

- (void)clickBack:(UIButton *)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickPhoto:(UIButton *)sender {
    WHC_PictureListVC * vc = [WHC_PictureListVC new];
    vc.delegate = self;
    vc.maxChoiceImageNumber = 1;
    UINavigationController * nv = [[UINavigationController alloc] initWithRootViewController:vc];
    nv.navigationBar.tintColor = [UIColor blueColor];
    vc.navigationItem.title = @"选择照片";
    [self presentViewController:nv animated:YES completion:nil];
}

- (void)clickLightning:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self openLightning:sender.selected];
}

- (void)clickMyQRCode:(UIButton *)sender {
    UIImage * image = [WHC_QRCodeVC becomeQRCodeImageWithQRUrl:_myQRCodeUrl size:CGSizeMake(200, 200)];
    if (_delegate && [_delegate respondsToSelector:@selector(WHCQRCodeVCBecomeQRCodeImage:)]) {
        [self clickBack:nil];
        [_delegate WHCQRCodeVCBecomeQRCodeImage:image];
    }
}

#pragma mark - ZXCaptureDelegate
- (void)captureResult:(ZXCapture *)capture
               result:(ZXResult *)result {
    if (!result) return;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [_captureDevice stop];
    if (_delegate && [_delegate respondsToSelector:@selector(WHCQRCodeVCScanCallBack:isQRCode:)]) {
        [self clickBack:nil];
        [_delegate WHCQRCodeVCScanCallBack:result.text
                                  isQRCode:(result.barcodeFormat == kBarcodeFormatQRCode ? YES : NO)];
    }
}

#pragma mark - WHC_ChoicePictureVCDelegate
- (void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC
       didSelectedPhotoArr:(NSArray *)photoArr {
    UIImage * loadImage = photoArr[0];
    ZXResult * result = [WHC_QRCodeVC scanQRCodeImage:loadImage];
    [self captureResult:_captureDevice result:result];
}

#pragma mark - 类方法
+ (UIImage *)becomeQRCodeImageWithQRUrl:(NSString *)url
                                   size:(CGSize)size {
    
    NSAssert(url, @"二维码路径不能为空");
    ZXMultiFormatWriter * writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix * result = [writer encode:url
                                  format:kBarcodeFormatQRCode
                                   width:size.width
                                  height:size.height
                                   error:nil];
    
    CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
    UIImage *qrImage = [UIImage imageWithCGImage:image];
    return qrImage;
}

+ (ZXResult *)scanQRCodeImage:(UIImage *)QRImage {
    NSAssert(QRImage, @"二维码图片不能为空");
    UIImage * loadImage = QRImage;
    CGImageRef imageToDecode = loadImage.CGImage;
    ZXLuminanceSource * source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap * bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    NSError * error = nil;
    ZXDecodeHints * hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader * reader = [ZXMultiFormatReader reader];
    ZXResult * result = [reader decode:bitmap
                                 hints:hints
                                 error:&error];
    return result;
}
@end
