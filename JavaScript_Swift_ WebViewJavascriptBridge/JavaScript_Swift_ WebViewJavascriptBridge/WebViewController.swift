//
//  WebViewController.swift
//  JavaScript_Swift_ WebViewJavascriptBridge
//
//  Created by xiaovv on 2017/4/12.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit
import AVFoundation

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var webView: UIWebView?
    var webViewBridge: WebViewJavascriptBridge?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        navigationItem.title = "UIWebView-javascriptBridge"
        
        setupWebView()
        
        registerNativeFunctions()
    }
    
    deinit {
        print(#function)
    }
    
    func setupWebView() {
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(rightClick))
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        // 取消不想要webView 的回弹效果
        self.webView?.scrollView.bounces = false
        
        // UIWebView 滚动的比较慢，这里设置为正常速度
        self.webView?.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        
        let url = Bundle.main.url(forResource: "index.html", withExtension: nil)
        
        let request = NSURLRequest(url: url!)
        
        self.webView?.loadRequest(request as URLRequest)
        
        self.view.addSubview(self.webView!)
        
        WebViewJavascriptBridge.enableLogging()
        
        self.webViewBridge = WebViewJavascriptBridge.init(forWebView: self.webView)
        
        self.webViewBridge?.setWebViewDelegate(self)
        
    }
    
    //MARK: - Method
    
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
            
            self.webView?.goBack()
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

}
