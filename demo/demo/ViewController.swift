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

        self.setupWechatManager()
    }

    @IBAction func getUserInfo(_ sender: AnyObject) {
        guard let openid = WechatManager.shared.openid else {
            print("还没有登录")
            return
        }

        guard openid.characters.count > 0 else {
            print("还没有登录,或openid没有正确设置")
            return
        }
        WechatManager.shared.getUserInfo { result in
            switch result {
            case .failure(let errCode):
                print(errCode)
            case .success(let value):
                print(value)
            }
        }
    }
    /**
     登录

     - parameter sender: sender description
     */
    @IBAction func login(_ sender: AnyObject) {
//        WXApi.getApiVersion() //所有微信SDK都可以直接调用

        if !WechatManager.shared.isInstalled() {
            print("not install, it will open a webview")
        }
        WechatManager.shared.checkAuth { result in
            switch result {
            case .failure(let errCode):
                print(errCode)
            case .success(let value):
                print(value)
            }
        }
    }
    /**
     退出登录

     - parameter sender: sender description
     */
    @IBAction func logout(_ sender: AnyObject) {
        WechatManager.shared.logout()
    }
    /**
     分享

     - parameter sender: sender description
     */
    @IBAction func share(_ sender: AnyObject) {
        WechatManager.shared.share(WXSceneSession, image: nil, title: "test", description: "@WechatKit")
    }

}
extension ViewController {
    fileprivate func setupWechatManager() {
        //设置appid
        WechatManager.appid = "wxd930ea5d5a258f4f"
        WechatManager.appSecret = ""//如果不设置 appSecret 则无法获取access_token 无法完成认证

        //设置分享Delegation
        WechatManager.shared.shareDelegate = self
    }
}

// MARK: - WechatManagerShareDelegate
extension ViewController: WechatManagerShareDelegate {
    //app分享之后 点击分享内容自动回到app时调用 该方法
    public func showMessage(_ message: String) {
        print(message)
    }
}
