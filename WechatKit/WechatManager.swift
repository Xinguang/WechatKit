//
//  WechatManager.swift
//  WechatKit
//
//  Created by starboychina on 2015/12/02.
//  Copyright © 2015年 starboychina. All rights reserved.
//

import Foundation
import Alamofire

/// WechatManager
public class WechatManager: NSObject {
    /// 微信开放平台,注册的应用程序id
    public static var appid: String! {
        didSet {
            WXApi.registerApp(appid)
        }
    }
    /// 微信开放平台,注册的应用程序Secret
    public static var appSecret: String!
    /// openid
    public static var openid: String!
    /// access token
    public static var access_token: String!
    /// refresh token
    public static var refresh_token: String!
    /// csrf
    public static var csrf_state = "73746172626f796368696e61"
    /// 认证Delegation
    public var authDelegate: WechatManagerAuthDelegate!
    /// 分享Delegation
    public var shareDelegate: WechatManagerShareDelegate?
    /// A shared instance
    public static let sharedInstance: WechatManager = {
        let instalce = WechatManager()
        instalce.authDelegate = instalce
        return WechatManager()
    }()
    
    /**
     检查微信是否已被用户安装
     
     - returns: 微信已安装返回true，未安装返回false
     */
    public func isInstalled() -> Bool {
        return WXApi.isWXAppInstalled()
    }
    
    /**
     处理微信通过URL启动App时传递的数据
     
     需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     
     - parameter url: 微信启动第三方应用时传递过来的URL
     
     - returns: 成功返回true，失败返回false
     */
    public func handleOpenURL(url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: WechatManager.sharedInstance)
    }
    
}



// MARK: WeiChatDelegate

extension WechatManager: WXApiDelegate {
    /**
    收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
    * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
    * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
    
    - parameter req: 具体请求内容，是自动释放的
    */
    public func onReq(req:BaseReq){
        if let temp = req as? ShowMessageFromWXReq {
            self.shareDelegate?.showMessage(temp.message.messageExt)
        }
    }
    /**
    发送一个sendReq后，收到微信的回应
    
    * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
    * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等
    
    - parameter resp: 具体的回应内容，是自动释放的
    */
    public func onResp(resp:BaseResp) {
        if let temp = resp as? SendAuthResp {
            if (0 == temp.errCode && WechatManager.csrf_state == temp.state) {
                self.getAccessToken(temp.code)
            } else {
                self.authDelegate.failure(Int(temp.errCode))
            }
        }
    }
    
}

// MARK: - WechatManagerDelegate
// MARK: - 默认处理 -> 没设置authDelegate时的默认处理
extension WechatManager: WechatManagerAuthDelegate {
    /**
     微信认证成功
     
     - parameter res: 用户信息
     */
    public func success(res: AnyObject){
        print(res)
    }
    /**
     微信认证失败
     
     - parameter errCode: 返回认证错误码
     详见 https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419318634&token=&lang=zh_CN
     */
    public func failure(errCode: Int){
        print(errCode)
    }
}
