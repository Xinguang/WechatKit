//
//  WechatAuth.swift
//  WechatKit
//
//  Created by starboychina on 2015/12/03.
//  Copyright © 2015年 starboychina. All rights reserved.
//

// MARK: - public
extension WechatManager {
    /**
     微信认证
     
     - parameter completionHandler: 取得的token信息
     */
    public func checkAuth(completionHandler: AuthHandle) {
        
        if (!WXApi.isWXAppInstalled()) {
            // 微信没有安装
            completionHandler(.Failure(WXErrCodeUnsupport.rawValue))
        } else {
            self.completionHandler = completionHandler
            if let _ = WechatManager.openid, _ = WechatManager.access_token, _ = WechatManager.refresh_token {
                self.checkToken()
            } else {
                self.sendAuth()
            }
        }
    }
    /**
     获取微信用户基本信息
     
     - parameter completion: 微信基本用户信息
     */
    public func getUserInfo(completionHandler: AuthHandle) {
        self.completionHandler = completionHandler
        
        AlamofireController.request(WechatRoute.Userinfo) { result in
            
            if let err = result["errcode"] as? Int32 {
//                let _ = result["errmsg"] as! String
                completionHandler(.Failure(err))
                return
            }
            
            self.completionHandler(.Success(result))
        }
    }
    /**
     退出
     */
    public func logout(){
        WechatManager.openid = ""
        WechatManager.access_token = ""
        WechatManager.refresh_token = ""
    }
}

// MARK: - private
extension WechatManager {
    
    private func sendAuth(){
        
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = WechatManager.csrf_state
        
        WXApi.sendReq(req)
    }
    
    private func checkToken() {
        
        AlamofireController.request(WechatRoute.CheckToken) { result in
            
            if !result.keys.contains("errcode") {
                self.completionHandler(.Success(result))
                return
            }
            
            self.refreshAccessToken()
        }
    }
    
    func getAccessToken(code: String) {
        
        AlamofireController.request(WechatRoute.AccessToken(code)) { result in
            
            if let err = result["errcode"] as? Int32 {
//                let _ = result["errmsg"] as! String
                self.completionHandler(.Failure(err))
                return
            }
            
            self.saveOpenId(result)
        }
    }
    
    private func refreshAccessToken() {
        
        AlamofireController.request(WechatRoute.RefreshToken) { result in
            
            if !result.keys.contains("errcode") {
                self.saveOpenId(result)
            } else {
                self.sendAuth()
            }
        }
    }
    
    private func saveOpenId(info: Dictionary<String, AnyObject>) {
        WechatManager.openid = info["openid"] as? String
        WechatManager.access_token = info["access_token"] as? String
        WechatManager.refresh_token = info["refresh_token"] as? String
        
        self.completionHandler(.Success(info))
    }
}