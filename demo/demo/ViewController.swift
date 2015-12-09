//
//  ViewController.swift
//  demo
//
//  Created by starboychina on 2015/12/02.
//  Copyright © 2015年 starboychina. All rights reserved.
//

import UIKit
import WechatKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WechatManager.appid = "wxd930ea5d5a258f4f"
        WechatManager.appSecret = ""
        WechatManager.sharedInstance.authDelegate = self
        WechatManager.sharedInstance.shareDelegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
//        WXApi.getApiVersion()
        
        if WechatManager.sharedInstance.isInstalled() {
            WechatManager.sharedInstance.checkAuth()
            print("install")
        } else {
            print("not install")
        }
    }
    
    @IBAction func share(sender: AnyObject) {
        WechatManager.sharedInstance.share(WXSceneSession, image: nil, title: "test", description: "@WechatKit")
    }
    
}

// MARK: - WechatManagerAuthDelegate
extension ViewController: WechatManagerAuthDelegate {
    
    func success(res: AnyObject) {
        print(res)
    }
    
    func failure(errCode: Int) {
        print(errCode)
    }
}

// MARK: - WechatManagerShareDelegate
extension ViewController: WechatManagerShareDelegate {
    
    func showMessage(message: String) {
        print(message)
    }
}