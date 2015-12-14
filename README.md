#WechatKit

[![Build Status](https://travis-ci.org/starboychina/WechatKit.svg)](https://travis-ci.org/starboychina/WechatKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub release](https://img.shields.io/github/release/starboychina/WechatKit.svg)](https://github.com/starboychina/WechatKit/releases)

---
##Getting Started
- CocoaPods

```ogdl
pod 'WechatKit'
```

- Carthage

[安装Carthage](https://github.com/starboychina/WechatKit/blob/master/Carthage.md)

```ogdl
github "starboychina/WechatKit"
```

##Setting

- 设置URL scheme

    在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你在微信开放平台,注册的应用程序id

- IOS9以后 需要添加weixin到白名单

    添加以下内容到info.plist
```xml
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>wechat</string>
		<string>weixin</string>
	</array>
```
- 重写AppDelegate的handleOpenURL和openURL方法：

    在AppDelegate.swift中添加import WechatKit

```swift
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return self.application(application, openURL: url, sourceApplication: nil, annotation: [])
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WechatManager.sharedInstance.handleOpenURL(url)
    }
```

##Usage
- 注册app
```swift
  WechatManager.appid = "微信开放平台,注册的应用程序id"
  WechatManager.appSecret = "微信开放平台,注册的应用程序Secret"
```
- 检测微信是否安装
```swift
  WechatManager.sharedInstance.isInstalled()
```
- 使用微信认证
```swift
  WechatManager.sharedInstance.authDelegate = self
  WechatManager.sharedInstance.checkAuth()
```

- 分享到微信

```swift
  WechatManager.sharedInstance.shareDelegate = self
  /**
  分享

  - parameter scence:      请求发送场景
  - parameter image:       消息缩略图
  - parameter title:       标题
  - parameter description: 描述内容
  - parameter url:         地址
  - parameter extInfo:     app分享信息(点击分享内容返回程序时,会传给WechatManagerShareDelegate.showMessage(message: String)
  */
  WechatManager.sharedInstance.share(scence: WXScene, image: UIImage?, title: String, description: String, url: String? = default, extInfo: String? = default)
```

- Delegation
-
[认证Delegation](https://github.com/starboychina/WechatKit/blob/master/WechatKit/WechatManagerAuthDelegate.swift)

```swift
    func checkIfNeeded(completion: ((res: AnyObject?, errCode: Int?) -> ())) -> Bool

    func signupIfNeeded(parameters: [String : AnyObject], completion: ((res: AnyObject) -> ()))

    func success(res: AnyObject)

    func failure(errCode: Int)
```

[分享Delegation](https://github.com/starboychina/WechatKit/blob/master/WechatKit/WechatManagerShareDelegate.swift)

```swift
    func showMessage(message: String)
```
