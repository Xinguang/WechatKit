//
//  WechatRoute.swift
//  WechatKit
//
//  Created by starboychina on 2015/12/03.
//  Copyright © 2015年 starboychina. All rights reserved.
//

import Alamofire

enum WechatRoute: URLRequestConvertible {
    static let baseURLString = "https://api.weixin.qq.com/sns"
    
    case Userinfo
    case AccessToken(String)
    case RefreshToken
    case CheckToken
    
    var path: String {
        switch self {
        case .Userinfo:
            return "/userinfo"
        case .AccessToken:
            return "/oauth2/access_token"
        case .RefreshToken:
            return "/oauth2/refresh_token"
        case .CheckToken:
            return "/auth"            
        }
    }
    
    var parameters: [String: AnyObject] {
        switch self {
        case .Userinfo:
            return ["openid": WechatManager.openid ?? "", "access_token": WechatManager.access_token ?? ""]
        case .AccessToken(let code):
            return ["appid": WechatManager.appid, "secret": WechatManager.appSecret, "code": code, "grant_type": "authorization_code"]
        case .RefreshToken:
            return ["appid": WechatManager.appid, "refresh_token": WechatManager.refresh_token ?? "", "grant_type": "refresh_token"]
        case .CheckToken:
            return ["openid": WechatManager.openid ?? "", "access_token": WechatManager.access_token ?? ""]
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        
        let URL = NSURL(string: WechatRoute.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = Alamofire.Method.GET.rawValue
        
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        
    }
}

class AlamofireController {
    
    private static let badRequestCode = 400 //Bad Request
    
    class func request(route: WechatRoute, completion: (result: Dictionary<String, AnyObject> )->() ) {
 
        let request = Manager.sharedInstance.request(route).validate()
        
        request.responseJSON { res in
            if let result = res.result.value as? Dictionary<String, AnyObject> where res.result.error == nil {
                completion(result: result)
            } else {
                let statusCode = res.response?.statusCode ?? badRequestCode
                WechatManager.sharedInstance.completionHandler?(.Failure(Int32(statusCode)))
            }
        }
    }
    
}