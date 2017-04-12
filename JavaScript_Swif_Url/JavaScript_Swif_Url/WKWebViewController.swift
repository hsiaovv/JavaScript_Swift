//
//  WKWebViewController.swift
//  JavaScript_Swif_Url
//
//  Created by xiaovv on 2017/4/8.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class WKWebViewController: UIViewController,WKNavigationDelegate, WKUIDelegate {
    
    var wkWebView:WKWebView?
    var progressView:UIProgressView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "WKWebView拦截url"
        
        setupWKWebView()
        
        setupProgressView()
        
        self.wkWebView?.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    
    deinit {
        
        print(#function)
        
        self.wkWebView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    func setupWKWebView() {
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        preferences.minimumFontSize = 30.0
        
        configuration.preferences = preferences
        
        self.wkWebView = WKWebView(frame: self.view.frame, configuration: configuration)
        
//        let urlStr = "http://www.jianshu.com/p/e99ed60390a8"
//        let url = URL(string: urlStr)
//        let request = URLRequest(url: url!)
//        self.wkWebView?.load(request)
        
        let urlStr = Bundle.main.path(forResource: "index.html", ofType: nil)
        let url = URL(fileURLWithPath: urlStr!)
        self.wkWebView?.loadFileURL(url, allowingReadAccessTo: url)
        
        self.wkWebView?.navigationDelegate = self
        self.wkWebView?.uiDelegate = self
        
        self.view.addSubview(self.wkWebView!)
        
    }
    
    func setupProgressView() {
        
        let kScreenWidth = UIScreen.main.bounds.size.width
        
        self.progressView = UIProgressView(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: 2))
        
        self.progressView?.trackTintColor = UIColor.blue
        self.progressView?.trackTintColor = UIColor.lightGray
        
        
        self.view.addSubview(self.progressView!)
        
    }
    
    
    func handleCustomAction(url:URL) {
        
        let host = url.host!
        
        switch host {
        case "scanClick":
            print("saoyisao")
            
        case "shareClick":
            
            share(url: url)
            
        case "getLocation":
            
            getLocation()
            
        case "setColor":
            
            changeBackGroundColor(url: url)
            
        case "payAction":
            
            payAction(url: url)
            
        case "shake":
            
            sharkeAction()
            
        case "back":
            
            goBack()
            
        default:
            break
        }
        
    }
    
    //MARK: - methond
    //用js把参数传给swift
    func share(url: URL) {
        
        let params = url.query?.removingPercentEncoding?.components(separatedBy: "&")
        
        var paramDic = [String: String]()
        
        for paramStr in params! {
            
            let arr = paramStr.components(separatedBy: "=")
            
            if arr.count > 1 {
                
                paramDic[arr[0]] = String.init(arr[1].utf8)
                
            }
        }
        
        let title = paramDic["title"] ?? ""
        
        let content = paramDic["content"] ?? ""
        
        let shareUrl = paramDic["url"] ?? ""
        
        //以上从js了获取到了要分享的内容，然后在swift里面执行分享操作
        
        let jsStr = "shareResult('\(title)','\(content)','\(shareUrl)')"
        
        //WKWebView 提供了一个新的方法evaluateJavaScript:completionHandler:，实现原生 调用JS 等场景。
        self.wkWebView?.evaluateJavaScript(jsStr, completionHandler: { (result, error) in
            
            print("result:\(String(describing: result)) error:\(String(describing: error))")
        })
        
    }
    
    //将swift的内容回调到JS中
    func getLocation() {
        
        //获取位置信息
        
        //将获取的位置信息回调到js
        let jsStr = "setLocation('广东省深圳市南山区')"
        
        //WKWebView 提供了一个新的方法evaluateJavaScript:completionHandler:，实现原生 调用JS 等场景。
        self.wkWebView?.evaluateJavaScript(jsStr, completionHandler: { (result, error) in
            
            print("result:\(String(describing: result)) error:\(String(describing: error))")
        })
        
    }
    
    func changeBackGroundColor(url: URL) {
        
        let params = url.query?.removingPercentEncoding?.components(separatedBy: "&")
        
        var paramDic = [String: String]()
        
        for paramStr in params! {
            
            let arr = paramStr.components(separatedBy: "=")
            
            if arr.count > 1 {
                
                paramDic[arr[0]] = String.init(arr[1].utf8)
                
            }
        }
        
        let red = Float(paramDic["r"]!)! / 255.0
        let green = Float(paramDic["g"]!)! / 255.0
        let blue = Float(paramDic["b"]!)! / 255.0
        
        self.view?.backgroundColor = UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: 1.0)
        
    }
    
    
    func payAction(url: URL)  {
        
        let params = url.query?.removingPercentEncoding?.components(separatedBy: "&")
        
        var paramDic = [String: String]()
        
        for paramStr in params! {
            
            let arr = paramStr.components(separatedBy: "=")
            
            if arr.count > 1 {
                
                paramDic[arr[0]] = String.init(arr[1].utf8)
                
            }
        }
        
        let orderNo = paramDic["order_no"] ?? ""
        
        let amount = paramDic["amount"] ?? ""
        
        let subject = paramDic["subject"] ?? ""
        
        let channel = paramDic["channel"] ?? ""
        
        print("订单号：\(orderNo)价格：\(amount)尺码：\(subject)描述：\(channel)")
        
        // 支付操作
        
        let jsStr = "payResult('支付成功',\(1))"
        
        //WKWebView 提供了一个新的方法evaluateJavaScript:completionHandler:，实现原生 调用JS 等场景。
        self.wkWebView?.evaluateJavaScript(jsStr, completionHandler: { (result, error) in
            
            print("result:\(String(describing: result)) error:\(String(describing: error))")
        })
        
    }
    
    func sharkeAction()  {
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    
    func goBack() {
        
        self.wkWebView?.goBack()
    }
    

    // MARK: - progress KVO
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

    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.url?.scheme == "haleyaction" {
            
            let url = navigationAction.request.url
            
            handleCustomAction(url: url!)
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            
            return
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
 
    //MARK: -  WKUIDelegate
    //如果在WKWebView中使用alert、confirm 等弹窗，就得实现WKWebView的WKUIDelegate中相应的代理方法。例如，我在JS中要显示alert 弹窗，就必须实现如下代理方法，否则alert 并不会弹出。

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
