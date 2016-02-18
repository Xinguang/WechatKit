//
//  WechatManagerAuthDelegate.swift
//  WechatKit
//
//  Created by starboychina on 2015/12/03.
//  Copyright © 2015年 starboychina. All rights reserved.
//
/**
*  Auth
*/
public protocol WechatManagerAuthDelegate {
    /**
     认证成功时调用
     
     - parameter res:
     如果实现了checkIfNeeded 并且服务器认证成功时,返回 系统用户信息,认证失败401时,返回新的access_token及refresh_token
     如果没有实现checkIfNeeded ,则返回 微信用户的基本信息
     */
    func success(res: AnyObject)
    /**
     认证失败
     
     - parameter errCode: 返回认证错误码
     详见 https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419318634&token=&lang=zh_CN
     
     */
    func failure(errCode: Int)
}