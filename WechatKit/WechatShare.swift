//
//  WechatShare.swift
//  WechatKit
//
//  Created by starboychina on 2015/12/03.
//  Copyright © 2015年 starboychina. All rights reserved.
//

// MARK: Share

extension WechatManager {
    /**
    分享

    - parameter scence:      请求发送场景
    - parameter image:       消息缩略图
    - parameter title:       标题
    - parameter description: 描述内容
    - parameter url:         地址
    - parameter extInfo:     app分享信息
     (点击分享内容返回程序时,会传给WechatManagerShareDelegate.showMessage(message: String)
    */
    public func share(_ scence: WXScene,
                      image: UIImage?,
                      title: String,
                      description: String,
                      url: String? = "https://open.weixin.qq.com/",
                      extInfo: String? = nil) {

        var message = self.getRequestMesage(image, title: title, description: description)

        if let extInfo = extInfo {
            message = self.shareApp(message, url: url, extInfo: extInfo)
        } else {
            message = self.shareUrl(message, url: url)
        }

        self.sendReq(message, scence: scence)
    }

    //share url
    fileprivate func shareUrl(_ message: WXMediaMessage, url: String?) -> WXMediaMessage {
        message.mediaTagName = "WECHAT_TAG_JUMP_SHOWRANK"

        let ext = WXWebpageObject()
        ext.webpageUrl = url
        message.mediaObject = ext

        return message
    }
    /**
     share app

     - parameter message: message description
     - parameter url:     url description
     - parameter extInfo: extInfo description

     - returns: return value description
     */
    fileprivate func shareApp(_ message: WXMediaMessage, url: String?, extInfo: String)
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

    //get message
    fileprivate func getRequestMesage(_ image: UIImage?, title: String, description: String)
        -> WXMediaMessage {

            let message = WXMediaMessage()
            /** 描述内容
             * @note 长度不能超过1K
             */
            if description.characters.count > 128 {

                let startIndex = description.startIndex
                let to = description.index(after: description.index(startIndex, offsetBy: 128))

                message.description = description.substring(to: to)
            } else {
                message.description = description
            }

            /** 缩略图数据
             * @note 大小不能超过32K
             */
            let thumbImage = image == nil ? UIImage() : self.resizeImage(image!, newWidth: 100)

            message.setThumbImage(thumbImage)

            /** 标题
             * @note 长度不能超过512字节
             */
            if title.characters.count > 64 {

                let startIndex = title.startIndex
                let to = title.index(after: title.index(startIndex, offsetBy: 64))

                message.title = title.substring(to: to)
            } else {
                message.title = title
            }

            return message
    }

    fileprivate func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {

        let newHeight = image.size.height / image.size.width * newWidth
        UIGraphicsBeginImageContext( CGSize(width: newWidth, height: newHeight) )
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    //send request
    fileprivate func sendReq(_ message: WXMediaMessage, scence: WXScene) {
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(scence.rawValue)

        WXApi.send(req)
    }
}
