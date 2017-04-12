//
//  WebViewController.swift
//  JavaScript_Swif_Url
//
//  Created by xiaovv on 2017/4/8.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit
import AVFoundation

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var webView:UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "WebView拦截url"
        
        setupWebView()
    }
    
    
    func setupWebView() {
        
        self.webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        self.webView?.delegate = self
        
        // 取消不想要webView 的回弹效果
        self.webView?.scrollView.bounces = false
        
        // UIWebView 滚动的比较慢，这里设置为正常速度
        self.webView?.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        
        let url = Bundle.main.url(forResource: "index.html", withExtension: nil)

        let request = NSURLRequest(url: url!)
        
        self.webView?.loadRequest(request as URLRequest)
        
        self.view.addSubview(self.webView!)
        
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
        
        // 在这里执行分享的操作
        
        // 将分享结果返回给js
        let jsStr = "shareResult('\(title)','\(content)','\(shareUrl)')"
        
        self.webView?.stringByEvaluatingJavaScript(from: jsStr)
        
    }
    
    //将swift的内容回调到JS中
    func getLocation() {
        
        //获取位置信息
        
        //将获取的位置信息回调到js
        let jsStr = "setLocation('广东省深圳市南山区')"
        
        self.webView?.stringByEvaluatingJavaScript(from: jsStr)
        
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
        
        let red = Float(paramDic["r"]!)
        let green = Float(paramDic["g"]!)
        let blue = Float(paramDic["b"]!)
        
        self.webView?.backgroundColor = UIColor.init(colorLiteralRed: red!, green: green!, blue: blue!, alpha: 1.0)
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
        
        self.webView?.stringByEvaluatingJavaScript(from: jsStr)
        
    }
    
    func sharkeAction()  {
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    
    func goBack() {
        
        self.webView?.goBack()
    }
    
    
    //MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = request.url
        
        if url?.scheme == "haleyaction" {
            
            handleCustomAction(url: url!)
            
            return false
        }
        
        return true
    }

    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webView.stringByEvaluatingJavaScript(from: "var arr = [3, 4, 'abc']")
    }
}
