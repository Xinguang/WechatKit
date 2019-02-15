//
//  WechatShare.swift
//  WechatKit
//
//  Created by starboychina on 2015/12/03.
//  Copyright © 2015年 starboychina. All rights reserved.
//

// MARK: - 分享
extension WechatManager {
    /// 分享
    ///
    /// - Parameters:
    ///   - scence: 请求发送场景
    ///   - image: 消息缩略图
    ///   - title: 标题
    ///   - description: 描述内容
    ///   - url: 地址
    ///   - extInfo: app分享信息
    ///      (点击分享内容返回程序时,会传给WechatManagerShareDelegate.showMessage(message: String)
    public func share(_ scence: WXScene,
                      image: UIImage?,
                      title: String,
                      description: String,
                      url: String = "https://open.weixin.qq.com/",
                      extInfo: String? = nil) {

        var message = self.getRequestMesage(image, title: title, description: description)

        if let extInfo = extInfo {
            message = self.shareApp(message, url: url, extInfo: extInfo)
        } else {
            message = self.shareUrl(message, url: url)
        }

        self.sendReq(message, scence: scence)
    }

    /// 分享 Url
    ///
    /// - Parameters:
    ///   - message: 多媒体消息结构体
    ///   - url: 分享的 Url
    /// - Returns: 多媒体消息结构体
    fileprivate func shareUrl(_ message: WXMediaMessage,
                              url: String = "https://open.weixin.qq.com/") -> WXMediaMessage {
        message.mediaTagName = "WECHAT_TAG_JUMP_SHOWRANK"

        let ext = WXWebpageObject()
        ext.webpageUrl = url
        message.mediaObject = ext

        return message
    }

    /// 获取 app 分享的多媒体消息结构体
    ///
    /// - Parameters:
    ///   - message: 多媒体消息结构体
    ///   - url: 未安装 app 时打开的 Url
    ///   - extInfo: app分享信息
    /// - Returns: 多媒体消息结构体
    fileprivate func shareApp(_ message: WXMediaMessage, url: String = "https://open.weixin.qq.com/", extInfo: String)
        -> WXMediaMessage {
            message.messageExt = extInfo//"附加消息：Come from 現場TOMO" //返回到程序之后用
            message.mediaTagName = "WECHAT_TAG_JUMP_APP"
            //message.messageAction = "<action>\(messageAction)</action>" //不能返回  ..返回到程序之后用

            let ext = WXAppExtendObject()
            //        ext.extInfo = extInfo //返回到程序之后用
            ext.url = url;//分享到朋友圈时的链接地址
            let buffer: [UInt8] = [0x00, 0xff]
            let data = Data(bytes: UnsafePointer<UInt8>(buffer), count: buffer.count)
            ext.fileData = data

            message.mediaObject = ext

            return message
    }

    /// 获取多媒体消息结构体
    /// 用于微信终端和第三方程序之间传递消息的多媒体消息内容
    ///
    /// - Parameters:
    ///   - image: 需要分享的图片
    ///   - title: 标题
    ///   - description: 简介
    /// - Returns: 多媒体消息结构体
    fileprivate func getRequestMesage(_ image: UIImage?, title: String, description: String)
        -> WXMediaMessage {

            let message = WXMediaMessage()
            /** 描述内容
             * @note 长度不能超过1K
             */
            if description.count > 128 {

                let startIndex = description.startIndex
                let end = description.index(after: description.index(startIndex, offsetBy: 128))

                message.description = String(description[..<end])
            } else {
                message.description = description
            }

            /** 缩略图数据
             * @note 大小不能超过64K
             */
            let thumbImage = image == nil ? UIImage() : self.resizeImage(image!, newWidth: 144)

            message.setThumbImage(thumbImage)

            /** 标题
             * @note 长度不能超过512字节
             */
            if title.count > 64 {

                let startIndex = title.startIndex
                let end = title.index(after: title.index(startIndex, offsetBy: 64))

                message.title = String(title[..<end])
            } else {
                message.title = title
            }

            return message
    }

    /// 重置图片大小
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - newWidth: 目标宽度
    /// - Returns: 重置后的图片
    fileprivate func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {

        let newHeight = image.size.height / image.size.width * newWidth
        UIGraphicsBeginImageContext( CGSize(width: newWidth, height: newHeight) )
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    /// 送请求到微信，等待微信返回onResp
    /// 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。
    ///
    /// - Parameters:
    ///   - message: <#message description#>
    ///   - scence: <#scence description#>
    fileprivate func sendReq(_ message: WXMediaMessage, scence: WXScene) {
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(scence.rawValue)

        WXApi.send(req)
    }
}
