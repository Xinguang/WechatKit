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
    public func checkAuth(_ completionHandler: @escaping AuthHandle) {

        if !WXApi.isWXAppInstalled() {
            // 微信没有安装
            completionHandler(.failure(WXErrCodeUnsupport.rawValue))
        } else {
            self.completionHandler = completionHandler
            if let _ = WechatManager.openid,
                let _ = WechatManager.accessToken,
                let _ = WechatManager.refreshToken {
                self.checkToken()
            } else {
                self.sendAuth()
            }
        }
    }
    /**
     获取微信用户基本信息
     - parameter completionHandler: 微信基本用户信息
     */
    public func getUserInfo (_ completionHandler: @escaping AuthHandle) {
        self.completionHandler = completionHandler

        AlamofireController.request(WechatRoute.userinfo) { result in

            if let err = result["errcode"] as? Int32 {
//                let _ = result["errmsg"] as! String
                completionHandler(.failure(err))
                return
            }

            self.completionHandler(.success(result))
        }
    }
    /**
     退出
     */
    public func logout() {
        WechatManager.openid = ""
        WechatManager.accessToken = ""
        WechatManager.refreshToken = ""
    }
}

// MARK: - private
extension WechatManager {

    fileprivate func sendAuth() {

        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = WechatManager.csrfState

        WXApi.send(req)
    }

    fileprivate func checkToken() {

        AlamofireController.request(WechatRoute.checkToken) { result in

            if !result.keys.contains("errcode") {
                self.completionHandler(.success(result))
                return
            }

            self.refreshAccessToken()
        }
    }

    func getAccessToken(_ code: String) {

        AlamofireController.request(WechatRoute.accessToken(code)) { result in

            if let err = result["errcode"] as? Int32 {
//                let _ = result["errmsg"] as! String
                self.completionHandler(.failure(err))
                return
            }

            self.saveOpenId(result)
        }
    }

    fileprivate func refreshAccessToken() {

        AlamofireController.request(WechatRoute.refreshToken) { result in

            if !result.keys.contains("errcode") {
                self.saveOpenId(result)
            } else {
                self.sendAuth()
            }
        }
    }

    fileprivate func saveOpenId(_ info: [String: Any]) {
        WechatManager.openid = info["openid"] as? String
        WechatManager.accessToken = info["access_token"] as? String
        WechatManager.refreshToken = info["refresh_token"] as? String

        self.completionHandler(.success(info))
    }
}
