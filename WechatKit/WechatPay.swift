//
//  WechatPay.swift
//  WechatKit
//
//  Created by Benq on 2017/5/26.
//  Copyright © 2017年 starboychina. All rights reserved.
//

import Foundation

extension WechatManager {
    /// 支付
    ///
    /// - Parameters:
    ///   - partnerId: 商家向财付通申请的商家id
    ///   - prepayId: 预支付订单
    ///   - nonceStr: 随机串，防重发
    ///   - timeStamp: 时间戳，防重发
    ///   - package: 商家根据财付通文档填写的数据和签名
    ///   - sign: 商家根据微信开放平台文档对数据做的签名
    ///   - completionHandler: errCode: -1 其他错误、-2 取消支付
    public func pay(partnerId: String,
                    prepayId: String,
                    nonceStr: String,
                    timeStamp: Int,
                    package: String,
                    sign: String,
                    completionHandler: @escaping AuthHandle) {
        self.completionHandler = completionHandler
        let req = PayReq()
        req.partnerId = partnerId
        req.prepayId = prepayId
        req.nonceStr = nonceStr
        req.timeStamp = UInt32(timeStamp)
        req.package = package
        req.sign = sign
        self.sendPayReq(req)
    }
    
    fileprivate func sendPayReq(_ req: PayReq) {
        WXApi.send(req)
    }
    
}
