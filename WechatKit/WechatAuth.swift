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
     */
    public func checkAuth() {
        
        if (!WXApi.isWXAppInstalled()) {
            // 微信没有安装
            self.authDelegate.failure(Int(WXErrCodeUnsupport.rawValue))
        } else {
            if let _ = WechatManager.openid, _ = WechatManager.access_token, _ = WechatManager.refresh_token {
                self.checkToken()
            } else {
                self.sendAuth()
            }
        }
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
        
        self.checkTokenInServer { () -> () in
            
            AlamofireController.request(WechatRoute.CheckToken) { result in
                
                if !result.keys.contains("errcode") {
                    self.getUserInfo { userInfo in
                        self.authDelegate.success(userInfo)
                    }
                    return
                }
                
                self.refreshAccessToken { result in
                    self.getUserInfo { userInfo in
                        self.authDelegate.success(userInfo)
                    }
                }
            }
            
        }
    }
    
    func getAccessToken(code:String) {
        
        AlamofireController.request(WechatRoute.AccessToken(code)) { result in
            
            if let err = result["errcode"] as? Int {
                //                let _ = result["errmsg"] as! String
                self.authDelegate.failure(err)
                return
            }
            
            self.saveOpenId(result)
            
            self.checkTokenInServer { () -> () in
                
                self.getUserInfo { result in
                    self.authDelegate.success(result)
                }
            }
        }
    }
    
    private func refreshAccessToken(completion: (result: Dictionary<String, AnyObject>)->()) {
        
        AlamofireController.request(WechatRoute.RefreshToken) { result in
            
            if !result.keys.contains("errcode") {
                self.saveOpenId(result)
                completion(result: result)
                
            } else {
                self.sendAuth()
            }
        }
    }
    
    private func checkTokenInServer(checkByAppIfNeeded: ()->()) {
        
        let authCheckCompletion: ((res: AnyObject?, errCode:Int?) -> ()) = { (res, errCode) -> () in
            
            if let res = res {
                self.authDelegate.success(res)
                return
            }
            
            guard let errCode = errCode else {
                return
            }
            
            if errCode == 401 {
                self.refreshAccessToken{ result in
                    self.authDelegate.success(result)
                }
            } else if errCode == 404 {
                
                self.getUserInfo { userInfo in
                    //sign up                    
                    self.authDelegate.signupIfNeeded(userInfo, completion: self.authDelegate.success)
                }
            } else {
                self.authDelegate.failure(errCode)
            }
        }
        
        let checked = self.authDelegate.checkIfNeeded(authCheckCompletion) ?? false
        
        if !checked {
            checkByAppIfNeeded()
        }
    }
    
    private func getUserInfo(completion: (userInfo: Dictionary<String, AnyObject>)->()) {
        
        AlamofireController.request(WechatRoute.Userinfo) { result in
            
            if let err = result["errcode"] as? Int {
                //                let _ = result["errmsg"] as! String
                self.authDelegate.failure(err)
                return
            }
            
            completion(userInfo: result)
        }
    }
    
    private func saveOpenId(info: Dictionary<String, AnyObject>) {
        WechatManager.openid = info["openid"] as? String
        WechatManager.access_token = info["access_token"] as? String
        WechatManager.refresh_token = info["refresh_token"] as? String
    }
}