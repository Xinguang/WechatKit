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

    @IBAction func login(sender: AnyObject) {
//        WXApi.getApiVersion() //所有微信SDK都可以直接调用
        
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
extension ViewController {
    private func setupWechatManager() {
        //设置appid
        WechatManager.appid = "wxd930ea5d5a258f4f"
        WechatManager.appSecret = ""//如果不设置 appSecret 则无法获取access_token 无法完成认证
        //设定已保存的openid、access_token, 以便实现自动登录
        WechatManager.openid = Defaults.stringForKey("openid")
        WechatManager.access_token = Defaults.stringForKey("access_token")
        WechatManager.refresh_token = Defaults.stringForKey("refresh_token")
        //设置Delegation
        WechatManager.sharedInstance.authDelegate = self
        WechatManager.sharedInstance.shareDelegate = self
    }
}

// MARK: - WechatManagerAuthDelegate
extension ViewController: WechatManagerAuthDelegate {
    /*
    //需要在自主服务器认证时 (非必须)
    func checkIfNeeded(completion: ((res: AnyObject?, errCode: Int?) -> ())) -> Bool {
        
        //在自己的服务器端认证 Alamofire.Manager.sharedInstance.request.....
        // 认证后 回调completion, 没有错误的时候 会直接调用success(res: AnyObject)
        // 有错误 则判断错误代码  
        //      如果401 错误 则重新获取access_token进行认证
        //      如果404 错误 则会调用WechatManagerAuthDelegate.signupIfNeeded
        //      其他错误 则会调用failure(errCode: Int)
        // 例如
        completion(res: ["username":"用户名"], errCode: nil)
        return true
    }
    //需要自动注册的时 (非必须)
    func signupIfNeeded(var parameters: [String : AnyObject], completion: ((res: AnyObject) -> ())) {
        //parameters 为微信的基本用户信息 设为var 时为了在该方法中能编辑 添加自定义属性 
        // 注册完成后 调用completion(res: 系统用户信息),则相当于 直接调用success(res: AnyObject)
        parameters["os"] = "iPhone"
        completion(res: parameters)
    }
    */
    //认证成功
    func success(res: AnyObject) {
        //保存获取的openid、access_token, 以便下次打开程序进行认证时使用
        Defaults.setObject(WechatManager.openid, forKey: "openid")
        Defaults.setObject(WechatManager.access_token, forKey: "access_token")
        Defaults.setObject(WechatManager.refresh_token, forKey: "refresh_token")
        
        print(res)
    }
    //认证失败
    func failure(errCode: Int) {
        print(errCode)
    }
}

// MARK: - WechatManagerShareDelegate
extension ViewController: WechatManagerShareDelegate {
    //app分享之后 点击分享内容自动回到app时调用 该方法
    func showMessage(message: String) {
        print(message)
    }
}