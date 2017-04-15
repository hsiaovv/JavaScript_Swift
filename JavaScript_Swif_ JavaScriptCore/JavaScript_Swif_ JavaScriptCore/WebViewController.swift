//
//  WebViewController.swift
//  JavaScript_Swif_ JavaScriptCore
//
//  Created by xiaovv on 2017/4/10.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit
import JavaScriptCore
import AVFoundation

@objc protocol SwiftJavaScriptDelegate:JSExport {
    
    func scanClick()
    
    func locationClick()

    //多参数注意 js里面的方法的写法，需要在方法名里带参数名
    func share(_ title: String, content: String, url:String)
    
    //以下两个方法直接从js传json字符串，避免上面的问题
    func changeColor(_ colorInfo: String)
    
    func pay(_ payInfo: String)
    
    func shake()
    
    func goBack()

}

class WebViewController: UIViewController, UIWebViewDelegate,SwiftJavaScriptDelegate {
    
    var webView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "UIWebView-JavaScriptCore"
        
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
//        let url = URL(string: "http://www.jianshu.com/p/4db513ed2c1a")

        let request = NSURLRequest(url: url!)
        
        self.webView?.loadRequest(request as URLRequest)
        
        self.view.addSubview(self.webView!)
        
    }

    //MARK: - UIWebViewDelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        let context = self.webView?.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        context.setObject(self, forKeyedSubscript: "JavaScriptCoreBridge" as NSCopying & NSObjectProtocol)
        
        
        context.exceptionHandler = {context, exceptionValue in
            
            print(exceptionValue ?? "")
        }
        
    }
    
    //MARK: - SwiftJavaScriptDelegate
    
    func scanClick() {
        
        print("调用相机扫一扫")
    }
    
    func locationClick() {
        
        self.webView?.stringByEvaluatingJavaScript(from: "setLocation('广东省深圳市南山区学府路XXXX号')")
    }
    
    func share(_ title: String, content: String, url: String) {
        
        let jsStr = "shareResult('\(title)', '\(content)', '\(url)')"
        
        self.webView?.stringByEvaluatingJavaScript(from: jsStr)
        
    }
    
    func changeColor(_ colorInfo: String) {
        
        if !colorInfo.isEmpty {
           
            let colorData = colorInfo.data(using: .utf8)
            
            if let colorDic =  try? JSONSerialization.jsonObject(with: colorData!, options: .mutableContainers) as! [String: String] {
                
                if colorDic.count == 4 {
                    
                    let r = Float(colorDic["red"]!)! / 255.0
                    let g = Float(colorDic["green"]!)! / 255.0
                    let b = Float(colorDic["blue"]!)! / 255.0
                    let a = Float(colorDic["alpha"]!)!
                    
                    self.view.backgroundColor = UIColor(colorLiteralRed: r, green: g, blue: b, alpha: a)
        
                }
            }
        }
        
    }
    
    func pay(_ payInfo: String) {
        
        if !payInfo.isEmpty {
            
            let payInfoData = payInfo.data(using: .utf8)
            
            if let payInfoDic = try? JSONSerialization.jsonObject(with: payInfoData!, options: .mutableContainers) as! [String: String] {
                
                print("支付信息：\(payInfoDic)")
                
                self.webView?.stringByEvaluatingJavaScript(from: "payResult('支付成功')")
//                JSContext.current().objectForKeyedSubscript("payResult").call(withArguments: ["支付成功"])
//                JSContext.current().evaluateScript("payResult('支付成功')")
            }
            
        }
    }
    
    func shake() {
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    func goBack() {
        
        self.webView?.goBack()
    }
    
    func creatJSContext() {
        
        // 1.这种方式需要传入一个JSVirtualMachine对象，如果传nil，会导致应用崩溃的。
        let JSVM = JSVirtualMachine()
        let JSCtx1 = JSContext(virtualMachine: JSVM)
        // 2.这种方式，内部会自动创建一个JSVirtualMachine对象，可以通过JSCtx.virtualMachine
        // 看其是否创建了一个JSVirtualMachine对象。
        let JSCtx2 = JSContext()
        // 3. 通过webView的获取JSContext。
        let context = self.webView?.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext")
    }
}
