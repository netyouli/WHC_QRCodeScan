//
//  ViewController.swift
//  WHC_QRCodeScanKit
//
//  Created by 吴海超 on 15/12/26.
//  Copyright © 2015年 吴海超. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,WHC_QRCodeVCDelegate {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }
    
    convenience init(nibName: String){
        self.init(nibName: nibName,bundle: NSBundle.mainBundle());
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func clickStart(sender: UIButton!) {
        let vc = WHC_QRCodeVC()
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func WHC_QRCodeVCScanCallBack(value: String, isQRCode: Bool) {
        if isQRCode {
            let vc = QRCodeWebVC(nibName: "QRCodeWebVC")
            vc.value = value
            self.presentViewController(vc, animated: true, completion: nil)
        }else {
            UIAlertView(title: value, message: nil, delegate: nil , cancelButtonTitle: "OK").show();
        }
    }
}

