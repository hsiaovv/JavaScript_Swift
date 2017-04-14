//
//  WKWebViewController.swift
//  JavaScript_Swif_ addScriptMessageHandler
//
//  Created by xiaovv on 2017/4/9.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class WKWebViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler {
    
    var wkWebView: WKWebView?
    
    var progressView: UIProgressView?
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "MessageHandler"
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(rightClick))
        
        self.navigationItem.rightBarButtonItem = rightItem
        setupWKWebView()
        
        setupProgressView()
        
        self.wkWebView?.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        // addScriptMessageHandler 很容易导致循环引用
        // 控制器 强引用了WKWebView,WKWebView copy(强引用了）configuration， configuration copy （强引用了）userContentController
        // userContentController 强引用了 self （控制器）
        
        /**
         
         window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
         其中<name>，就是上面方法里的第二个参数`name`。
         例如我们调用API的时候第二个参数填@"Share"，那么在JS里就是:
         window.webkit.messageHandlers.Share.postMessage(<messageBody>)
         <messageBody>是一个键值对，键是body，值可以有多种类型的参数。
         在`WKScriptMessageHandler`协议中，我们可以看到mssage是`WKScriptMessage`类型，有一个属性叫body。
         而注释里写明了body 的类型：
         Allowed types are NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull.
         
         */
        self.wkWebView?.configuration.userContentController.add(self as WKScriptMessageHandler, name: "ScanAction")
        self.wkWebView?.configuration.userContentController.add(self as WKScriptMessageHandler, name: "Location")
        self.wkWebView?.configuration.userContentController.add(self as WKScriptMessageHandler, name: "Share")
        self.wkWebView?.configuration.userContentController.add(self as WKScriptMessageHandler, name: "Color")
        self.wkWebView?.configuration.userContentController.add(self as WKScriptMessageHandler, name: "Pay")
        self.wkWebView?.configuration.userContentController.add(self as WKScriptMessageHandler, name: "Shake")
        self.wkWebView?.configuration.userContentController.add(self as WKScriptMessageHandler, name: "GoBack")
        self.wkWebView?.configuration.userContentController.add(self as WKScriptMessageHandler, name: "PlaySound")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
       // 因此这里要记得移除handlers
        self.wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "ScanAction")
        self.wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "Location")
        self.wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "Share")
        self.wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "Color")
        self.wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "Pay")
        self.wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "Shake")
        self.wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "GoBack")
        self.wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "PlaySound")
        
    }

    deinit {
        
        print(#function)
        
        self.wkWebView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    func rightClick() {
        
        
    }
    
    func setupWKWebView() {
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        preferences.minimumFontSize = 40.0
        
        configuration.preferences = preferences
        
        self.wkWebView = WKWebView(frame: self.view.frame, configuration: configuration)
        
        //        let urlStr = "http://www.jianshu.com/p/e99ed60390a8"
        //        let url = URL(string: urlStr)
        //        let request = URLRequest(url: url!)
        //        self.wkWebView?.load(request)
        
        let urlStr = Bundle.main.path(forResource: "index.html", ofType: nil)
        let url = URL(fileURLWithPath: urlStr!)
        self.wkWebView?.loadFileURL(url, allowingReadAccessTo: url)
        
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
    
    //MARK: - 
    func getLocation() {
        //获取位置信息
        
        //将获取的位置信息回调到js
        let jsStr = "setLocation('广东省深圳市南山区😄路')"
        
        //WKWebView 提供了一个新的方法evaluateJavaScript:completionHandler:，实现原生 调用JS 等场景。
        self.wkWebView?.evaluateJavaScript(jsStr, completionHandler: { (result, error) in
            
            print("result:\(String(describing: result)) error:\(String(describing: error))")
        })
        
        let  jsStr2 = "window.ctuapp_share_img"
        
        self.wkWebView?.evaluateJavaScript(jsStr2, completionHandler: { (result, error) in
            
            print("result:\(String(describing: result)) error:\(String(describing: error))")
        })
        
        
    }
    
    func share(params:[String: String]) {
        
        let title = params["title"] ?? ""
        
        let content = params["content"] ?? ""
        
        let  url = params["url"] ?? ""
        
        let jsStr = "shareResult('\(String(describing: title))','\(String(describing: content))','\(String(describing: url))')"
        
        self.wkWebView?.evaluateJavaScript(jsStr, completionHandler: { (result, error) in
            
            print("\(String(describing: result))---\(String(describing: error))")
        })
        
    }
    
    
    func changeBackGroundColor(params: [String: String]
        
        ) {
        
        if params.count < 4 {
            
            return
        }
        
        let red = Float(params["r"]!)! / 255.0
        let green = Float(params["g"]!)! / 255.0
        let blue = Float(params["b"]!)! / 255.0
        let alpha = Float(params["a"]!)
        
        self.view.backgroundColor = UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: alpha!)
        
    }
    
    func pay(params: [String: String]) {
        
        let orderNo = params["order_no"] ?? ""
        
        let amount = params["amount"] ?? ""
        
        let subject = params["subject"] ?? ""
        
        let channel = params["channel"] ?? ""
        
        print("订单号：\(orderNo) 价格：\(amount) 尺码：\(subject) 描述：\(channel)")
        
        // 支付操作
        
        let jsStr = "payResult('支付成功')"
        
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
    
    func palySound(soundName: String) {
        
        
        if self.player == nil {
         
            let url = Bundle.main.url(forResource: soundName, withExtension: nil)
            
            do {
                self.player = try AVAudioPlayer(contentsOf: url!)
                
                self.player?.prepareToPlay()
                
                
            } catch let error as NSError{
                
                print(error.localizedDescription)
            }
        }
        
        if !(self.player?.isPlaying)! {
            
            self.player?.play()
        }else {
            
            self.player?.pause()
        }
    
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
    
    //MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print(message.body)
        
        switch message.name {
            
        case "ScanAction":
            print("saoyisao")
            
        case "Location":
            
            getLocation()
            
        case "Share":
            
            share(params: message.body as! Dictionary)
            
        case "Color":
            
            changeBackGroundColor(params: message.body as! Dictionary)
            
        case "Pay":
            
            pay(params: message.body as! Dictionary)
            
        case "Shake":
            
            sharkeAction()
            
        case "GoBack":
            
            goBack()
            
        case "PlaySound":
            
            palySound(soundName: message.body as! String)
            
        default:
            break
        }
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
