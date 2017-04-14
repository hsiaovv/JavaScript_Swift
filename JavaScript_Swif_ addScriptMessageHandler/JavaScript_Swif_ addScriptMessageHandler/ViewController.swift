//
//  ViewController.swift
//  JavaScript_Swif_ addScriptMessageHandler
//
//  Created by xiaovv on 2017/4/9.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "主页"
    }

    @IBAction func addScriptMessageHandler(_ sender: UIButton) {
        
        let vc = WKWebViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

