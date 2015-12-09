//
//  WechatManager.swift
//  WechatKit
//
//  Created by starboychina on 2015/12/02.
//  Copyright © 2015年 starboychina. All rights reserved.
//

import Foundation
import Alamofire

public class WechatManager: NSObject {
    
    public static var appid: String! {
        didSet {
            WXApi.registerApp(appid)
        }
    }
    public static var appSecret: String!
    public static var openid: String?
    public static var access_token: String?
    public static var refresh_token: String?
    
    public static var csrf_state = "73746172626f796368696e61"
    
    public var authDelegate: WechatManagerAuthDelegate!
    public var shareDelegate: WechatManagerShareDelegate?
    
    public static let sharedInstance: WechatManager = {
        let instalce = WechatManager()
        instalce.authDelegate = instalce
        return WechatManager()
    }()
    
    public func isInstalled() -> Bool {
        return WXApi.isWXAppInstalled()
    }
    
    public func handleOpenURL(url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: WechatManager.sharedInstance)
    }
    
}



// MARK: WeiChatDelegate

extension WechatManager: WXApiDelegate {
    
    // WeChat request callback
    public func onReq(req:BaseReq){
        if let temp = req as? ShowMessageFromWXReq {
            self.shareDelegate?.showMessage(temp.message.messageExt)
        }
    }
    // WeChat response callback
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

extension WechatManager: WechatManagerAuthDelegate {
    
    public func success(res: AnyObject){
        
    }
    public func failure(errCode: Int){
        
    }
}
