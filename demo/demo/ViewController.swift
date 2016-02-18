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

    let Defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupWechatManager()
    }

    @IBAction func getUserInfo(sender: AnyObject) {
        guard let openid = WechatManager.openid else {
            print("还没有登录")
            return
        }
        
        guard openid.characters.count > 0 else {
            print("还没有登录,或openid没有正确设置")
            return
        }
        WechatManager.sharedInstance.getUserInfo { result in
            switch result {
            case .Failure(let errCode):
                print(errCode)
            case .Success(let value):
                print(value)
            }
        }
    }
    /**
     登录
     
     - parameter sender: sender description
     */
    @IBAction func login(sender: AnyObject) {
//        WXApi.getApiVersion() //所有微信SDK都可以直接调用
        
        if WechatManager.sharedInstance.isInstalled() {
            WechatManager.sharedInstance.checkAuth { result in
                switch result {
                case .Failure(let errCode):
                    print(errCode)
                case .Success(let value):
                    print(value)
                }
            }
        } else {
            print("not install")
        }
    }
    /**
     退出登录
     
     - parameter sender: sender description
     */
    @IBAction func logout(sender: AnyObject) {
        WechatManager.sharedInstance.logout()
    }
    /**
     分享
     
     - parameter sender: sender description
     */
    @IBAction func share(sender: AnyObject) {
        WechatManager.sharedInstance.share(WXSceneSession, image: nil, title: "test", description: "@WechatKit")
    }
    
}
extension ViewController {
    private func setupWechatManager() {
        //设置appid
        WechatManager.appid = "wxd930ea5d5a258f4f"
        WechatManager.appSecret = ""//如果不设置 appSecret 则无法获取access_token 无法完成认证
        
        //设置分享Delegation
        WechatManager.sharedInstance.shareDelegate = self
    }
}

// MARK: - WechatManagerShareDelegate
extension ViewController: WechatManagerShareDelegate {
    //app分享之后 点击分享内容自动回到app时调用 该方法
    func showMessage(message: String) {
        print(message)
    }
}