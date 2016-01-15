//
//  WechatManagerShareDelegate.swift
//  WechatKit
//
//  Created by starboychina on 2015/12/09.
//  Copyright © 2015年 starboychina. All rights reserved.
//

/**
*  share
*/
public protocol WechatManagerShareDelegate {
    /**
    APP分享时, 点击分享内容返回到App是调用
    
    - parameter message: ShowMessageFromWXReq.message.messageExt
    */
    func showMessage(message: String)
    
}

extension WechatManagerAuthDelegate {
    /**
     Default Implementation
     
     - parameter message: message description
     */
    public func showMessage(message: String) { print(message) }
}

