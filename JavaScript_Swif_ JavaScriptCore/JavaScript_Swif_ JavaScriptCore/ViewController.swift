//
//  ViewController.swift
//  JavaScript_Swif_ JavaScriptCore
//
//  Created by xiaovv on 2017/4/10.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func javaScriptCore(_ sender: UIButton) {
        
        let vc = WebViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

