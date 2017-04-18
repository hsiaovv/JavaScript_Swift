//
//  WKWebViewController.swift
//  JavaScript_Swift_ WebViewJavascriptBridge
//
//  Created by xiaovv on 2017/4/12.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit
import AVFoundation

class WKWebViewController: UIViewController, WKUIDelegate {
    
    var wkWebView: WKWebView?
    var progressView: UIProgressView?
    
    var webViewBridge: WKWebViewJavascriptBridge?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = "WKWebView-javascriptBridge"
        
        setupWKWebView()
        
        setupProgressView()
        
        registerNativeFunctions()
        
        self.wkWebView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    deinit {
        
        self.wkWebView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
    func setupWKWebView() {
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(rightClick))
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        preferences.minimumFontSize = 30.0
        
        configuration.preferences = preferences
        
        self.wkWebView = WKWebView(frame: self.view.frame, configuration: configuration)
        
//        let urlStr = "https://readhub.me/"
//        let url = URL(string: urlStr)
//        let request = URLRequest(url: url!)
//        self.wkWebView?.load(request)
        
        let urlStr = Bundle.main.path(forResource: "index.html", ofType: nil)
        let url = URL(fileURLWithPath: urlStr!)
        self.wkWebView?.loadFileURL(url, allowingReadAccessTo: url)
        
        self.wkWebView?.uiDelegate = self
        
        self.view.addSubview(self.wkWebView!)
        
        self.webViewBridge = WKWebViewJavascriptBridge.init(for: self.wkWebView)
        
        self.webViewBridge?.setWebViewDelegate(self)
    }
    
    func setupProgressView() {
        
        let kScreenWidth = UIScreen.main.bounds.size.width
        
        self.progressView = UIProgressView(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: 2))
        
        self.progressView?.trackTintColor = UIColor.blue
        self.progressView?.trackTintColor = UIColor.lightGray
        
        
        self.view.addSubview(self.progressView!)
        
    }
    
    //MARK: - registerMethod
    
    func registerNativeFunctions() {
        
        registerLocationFunction()
        
        registerScanFunction()
        
        registerShareFunction()
        
        registerPayFunction()
        
        registerBGColorFunction()
        
        registerShakeFunction()
        
        registerGoBackFunction()
    }
    
    func registerLocationFunction()  {
        
        self.webViewBridge?.registerHandler("locationClick", handler: { (data, responseCallback) in
            
            //这里获取位置信息
            let location = "广东省深圳市南山区学府路XXXX号"
            
            //将位置信息返回给js
            responseCallback!(location)
        })
    }
    
    func registerScanFunction() {
        
        self.webViewBridge?.registerHandler("scanClick", handler: { (data, responseCallback) in
            
            let scanResult = "https://www.baidu.com"
            
            responseCallback!(scanResult)
            
        })
    }
    
    func registerShareFunction() {
        
        self.webViewBridge?.registerHandler("shareClick", handler: { (data, responseCallback) in
            
            //获取js传过来的数据
            let dataDic = data as! [String: String]
            
            //执行分享操作
            let title = dataDic["title"]!
            let content = dataDic["content"]!
            let url = dataDic["url"]!
            
            //分享结果返回给js
            let result = "分享成功：\(title)\(content)\(url)"
            
            responseCallback!(result)
            
        })
        
    }
    
    func registerBGColorFunction() {
        
        self.webViewBridge?.registerHandler("colorClick", handler: { (data, responseCallback) in
            
            //获取js传过来的数据
            let dataDic = data as! [String: String]
            
            let r = Float(dataDic["r"]!)! / 255.0
            let g = Float(dataDic["g"]!)! / 255.0
            let b = Float(dataDic["b"]!)! / 255.0
            let a = Float(dataDic["a"]!)!
            
            self.view.backgroundColor = UIColor(colorLiteralRed: r, green: g, blue: b, alpha: a)
            
        })
    }
    
    func registerPayFunction() {
        
        self.webViewBridge?.registerHandler("payClick", handler: { (data, responseCallback) in
            
            //获取js传过来的数据
            let dataDic = data as! [String: String]
            
            //执行支付操作
            let orderno = dataDic["order_no"]!
            let amount = dataDic["amount"]!
            let channel = dataDic["channel"]!
            let subject = dataDic["subject"]!
            
            //分享结果返回给js
            let result = "分享成功：\(orderno)\(amount)\(channel)\(subject)"
            
            responseCallback!(result)
        })
    }
    
    func registerShakeFunction() {
        
        self.webViewBridge?.registerHandler("shakeClick", handler: { (data, responseCallback) in
            
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        })
    }
    
    func registerGoBackFunction() {
        
        self.webViewBridge?.registerHandler("goback", handler: { (data, responseCallback) in
            
            self.wkWebView?.goBack()
        })
    }
    
    
    func rightClick() {
        
        // 如果不需要参数，不需要回调，使用这个
        //        self.webViewBridge?.callHandler("testJSFunction")
        
        // 如果需要参数，不需要回调，使用这个
        //        self.webViewBridge?.callHandler("testJSFunction", data: "传一个字符串")
        
        self.webViewBridge?.callHandler("testJSFunction", data: "传一个字符串", responseCallback: { (resposeData) in
            
            print("调用完JS后的回调：\(String(describing: resposeData))")
        })
    }
    
    // MARK: - KVO wkWebView进度条
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let objc = object as! WKWebView
        
        if objc == self.wkWebView && keyPath == "estimatedProgress" {
            
            let newProgress = change?[.newKey] as! Float
            
            if newProgress == 1.0 {
                
                self.progressView?.setProgress(1.0, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    
                    self.progressView?.isHidden = true
                    self.progressView?.setProgress(0, animated: true)
                })
                
            }else {
                
                self.progressView?.isHidden = false
                self.progressView?.setProgress(newProgress, animated: true)
            }
            
        }
    }

    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "知道了", style:
        .cancel) { (action) in
            
            completionHandler()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

}
