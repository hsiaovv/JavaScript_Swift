//
//  ViewController.swift
//  JavaScript_Swift_ WebViewJavascriptBridge
//
//  Created by xiaovv on 2017/4/18.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func webViewClick(_ sender: UIButton) {
        
        let vc =  WebViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func wkWebViewClick(_ sender: UIButton) {
        
        let vc =  WKWebViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

