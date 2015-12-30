//
//  WHC_QRCodeVC.swift
//  WHC_QRCodeScanKit
//
//  Created by 吴海超 on 15/12/26.
//  Copyright © 2015年 吴海超. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol WHC_QRCodeVCDelegate {
    func WHC_QRCodeVCScanCallBack(value: String , isQRCode: Bool)
}

class WHC_QRCodeVC: UIViewController , AVCaptureMetadataOutputObjectsDelegate {

    private var scanView: UIView!
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let kScreenHeight = UIScreen.mainScreen().bounds.size.height
    private let kScreenWidth = UIScreen.mainScreen().bounds.size.width
    private let kCoverViewColor = UIColor(white: 0.2, alpha: 0.4)
    private let kScanViewWidth: CGFloat = 250
    private var captureDevice: AVCaptureDevice!
    private var scanMoveView: WHC_QRScanMoveView!
    private var hideStatus = true;
    weak var delegate: WHC_QRCodeVCDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData();
        self.layoutUI();
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        hideStatus = false;
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideStatus = true;
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prefersStatusBarHidden() -> Bool {
        return hideStatus
    }
    
    private func initData() {
    
    }
    
    private func layoutUI() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
        self.navigationController?.navigationBarHidden = true
        
        var deviceInput: AVCaptureDeviceInput!
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            try deviceInput = AVCaptureDeviceInput(device: captureDevice)
        }catch {
            print("创建扑捉输入设备错误")
        }
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession = AVCaptureSession()
        captureSession.addInput(deviceInput)
        captureSession.addOutput(metadataOutput);
        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_queue_create("WHC_SCAN", nil))
        metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode,
                                            AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = self.view.bounds;
        self.view.layer.addSublayer(previewLayer)
        self.makeUILayout()
        metadataOutput.rectOfInterest = CGRectMake(CGRectGetMinY(scanView.frame) / kScreenHeight, CGRectGetMinX(scanView.frame) / kScreenWidth, CGRectGetHeight(scanView.frame) / kScreenHeight, CGRectGetWidth(scanView.frame) / kScreenWidth)
        scanView.backgroundColor = UIColor.clearColor()
        captureSession.startRunning()
    }
    
    private func createButton(frame: CGRect, title: String, action: String) -> UIButton! {
        let cancelButton = UIButton(type: .Custom)
        cancelButton.frame = frame
        cancelButton.setTitle(title, forState: .Normal)
        cancelButton.addTarget(self, action: Selector(action), forControlEvents: .TouchUpInside)
        self.view.addSubview(cancelButton)
        return cancelButton
    }
    
    private func makeUILayout() {
        
        var y: CGFloat = 20 + 50 + 30
        var size: CGFloat = kScanViewWidth
        var x: CGFloat = (kScreenWidth - size) / 2
        scanView = UIView(frame: CGRectMake(x , y , size , size))
        scanView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(scanView)
        
        /// add Cover layer
        
        let scanCoverView = WHC_QRScanCoverView(frame: scanView.bounds)
        scanView.addSubview(scanCoverView)
        
        let topCoverView = UIView(frame: CGRectMake(0 , 0 , kScreenWidth , CGRectGetMinY(scanView.frame)))
        topCoverView.backgroundColor = kCoverViewColor
        self.view.addSubview(topCoverView)
        
        x = 20
        y = 20
        size = 50
        createButton(CGRectMake(x, y, size, size), title: "返回", action: "clickBack:")
        createButton(CGRectMake(kScreenWidth - size - x, y, size, size), title: "闪电", action: "clickLightning:")
        
        let leftCoverView = UIView(frame: CGRectMake(0, CGRectGetMinY(scanView.frame), (kScreenWidth - CGRectGetWidth(scanView.frame)) / 2, CGRectGetHeight(scanView.frame)))
        leftCoverView.backgroundColor = kCoverViewColor
        self.view.addSubview(leftCoverView)
        
        let rightCoverView = UIView(frame: CGRectMake(CGRectGetMaxX(scanView.frame) , CGRectGetMinY(scanView.frame), (kScreenWidth - CGRectGetWidth(scanView.frame)) / 2 , CGRectGetHeight(scanView.frame)))
        rightCoverView.backgroundColor = kCoverViewColor
        self.view.addSubview(rightCoverView)
        
        let bottomCoverView = UIView(frame: CGRectMake(0 , CGRectGetMaxY(scanView.frame), kScreenWidth , kScreenHeight - CGRectGetMaxY(scanView.frame)))
        bottomCoverView.backgroundColor = kCoverViewColor
        self.view.addSubview(bottomCoverView)
        
        y = CGRectGetMaxY(scanView.frame) + 20
        size = kScanViewWidth
        x = (kScreenWidth - size) / 2
        let promptLable = UILabel(frame: CGRectMake(x , y , size , 20))
        promptLable.text = "将二维码或条形码放入扫描框内,即可自动扫描"
        promptLable.textAlignment = .Center
        promptLable.minimumScaleFactor = 0.2
        promptLable.adjustsFontSizeToFitWidth = true
        promptLable.textColor = UIColor.whiteColor()
        promptLable.font = UIFont.systemFontOfSize(12)
        self.view.addSubview(promptLable)
        
        x = (kScreenWidth - size) / 2
        size = kScanViewWidth
        y = CGRectGetMaxY(promptLable.frame) + 10
        let myQRCodeButton = createButton(CGRectMake(x, y, size, 40), title: "我的二维码", action: "clickMyQRCode:")
        myQRCodeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        scanMoveView = WHC_QRScanMoveView(frame: CGRectMake(0,0,CGRectGetWidth(scanView.bounds), WHC_QRScanMoveView.kHeight))
        scanView.addSubview(scanMoveView)
        scanView.clipsToBounds = true
        self.startScanAnimation()
    }
    
    private func startScanAnimation() {
        UIView.animateWithDuration(1.5, delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.scanMoveView.frame = CGRectMake(0, CGRectGetHeight(self.scanView.bounds), CGRectGetWidth(self.scanView.bounds), WHC_QRScanMoveView.kHeight)
            }) { (finished) -> Void in
                self.scanMoveView.frame = CGRectMake(0, -WHC_QRScanMoveView.kHeight, CGRectGetWidth(self.scanView.bounds), WHC_QRScanMoveView.kHeight)
                self.startScanAnimation();
        }
    }
    
    private func openLightning(open: Bool) {
        if captureDevice.hasFlash && captureDevice.hasTorch {
            do {
                try captureDevice.lockForConfiguration()
            }catch {
                print("锁设备异常")
            }
            if open {
                captureDevice.torchMode = .On
                captureDevice.flashMode = .On
            }else {
                captureDevice.torchMode = .Off
                captureDevice.flashMode = .Off
            }
            captureDevice.unlockForConfiguration()
        }
    }
    
    //MARK: - ButtonAction
    
    func clickBack(sender: UIButton!) {
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clickPhoto(sender: UIButton!) {
        
    }
    
    func clickLightning(sender: UIButton!) {
        sender.selected = !sender.selected
        self.openLightning(sender.selected)
    }
    
    func clickMyQRCode(sender: UIButton!) {
        
    }
    
    //MARK: - 二维码代理
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects?.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            switch metadataObject.type {
                case AVMetadataObjectTypeQRCode:
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.delegate?.WHC_QRCodeVCScanCallBack(metadataObject.stringValue, isQRCode: true)
                    })
                    break;
                case AVMetadataObjectTypeEAN13Code,
                    AVMetadataObjectTypeEAN8Code,
                    AVMetadataObjectTypeCode128Code:
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.delegate?.WHC_QRCodeVCScanCallBack(metadataObject.stringValue, isQRCode: false)
                    })
                    break;
                default:
                    break;
            }
        }
    }

}
