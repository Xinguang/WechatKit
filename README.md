# WechatKit

[![Build Status](https://travis-ci.org/Xinguang/WechatKit.svg)](https://travis-ci.org/Xinguang/WechatKit)
[![Swift version](https://img.shields.io/badge/swift-3.0-orange.svg)](https://developer.apple.com/swift/)
[![Documentation](http://xinguang.github.io/WechatKit/badge.svg)](http://xinguang.github.io/WechatKit/)
[![SwiftLint](https://img.shields.io/badge/SwiftLint-passing-brightgreen.svg)](https://github.com/realm/SwiftLint)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/badge/CocoaPods-Compatible-4BC51D.svg?style=flat)](https://cocoapods.org/pods/WechatKit)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)
[![GitHub release](https://img.shields.io/github/release/starboychina/WechatKit.svg)](https://github.com/starboychina/WechatKit/releases)

---
## Getting Started
- CocoaPods

```ogdl
pod 'WechatKit'
```

- Carthage

[安装Carthage](https://github.com/starboychina/WechatKit/blob/master/Carthage.md)

```ogdl
github "starboychina/WechatKit"
```

## Setting

- 设置URL scheme

    在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你在微信开放平台,注册的应用程序id

![Setting](https://raw.githubusercontent.com/starboychina/WechatKit/master/demo/setting.png)

- IOS9以后 需要添加weixin到白名单(如图)

    或以源代码方式打开info.plist, 并添加以下内容.

```xml
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>wechat</string>
		<string>weixin</string>
	</array>
```
![Setting](https://raw.githubusercontent.com/starboychina/WechatKit/master/demo/info.plist.png)

- AppDelegate的handleOpenURL和openURL方法：

    在AppDelegate.swift中添加import WechatKit

```swift
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WechatManager.shared.handleOpenURL(url)
        // 如需要使用其他第三方可以 使用 || 连接 其他第三方库的handleOpenURL
        // return WechatManager.shared.handleOpenURL(url) || TencentOAuth.HandleOpenURL(url) || WeiboSDK.handleOpenURL(url, delegate: SinaWeiboManager.shared) ......
    }
```

## Usage
- 注册app

```swift
  WechatManager.appid = "微信开放平台,注册的应用程序id"
  WechatManager.appSecret = "微信开放平台,注册的应用程序Secret"
```
- 检测微信是否安装

```swift
  WechatManager.shared.isInstalled()
```
- 使用微信登录

    默认会记住openid,以及access_token,在token还在有效期时,调用checkAuth则不会打开微信客户端,直接使用token和微信服务器获取认证信息

```swift
    WechatManager.shared.checkAuth { result in
        switch result {
        case .failure(let errCode)://登录失败
            print(errCode)
        case .success(let value)://登录成功 value为([String: String]) 从微信返回的openid access_token 以及 refresh_token
            print(value) //当前是在子线程，如需回到主线程调用 DispatchQueue.main.async { print(value) }
        }
    }
```
- [**注意**]

    - *如果没有安装微信客户端,则会弹出 webview, 通过输入已绑定微信的手机号, 来接收认证短信, 然后在手机浏览器中,
    打开认证短信中的地址 (类似于:wxd930ea5d5a258f4f://wapoauth?m=KzgxNzAxMzExMTY2Ng%3D%3D&t=xxxx xxxx为4位数字), 会自动跳回你的 APP, 并且实现登录功能.*

    - *如果是 iPad 则不支持短信认证, 建议在 iPad 上接入微信登录时，先检测用户手机是否已安装微信客户端（使用WechatManager.shared.isInstalled()函数 ），对未安装的用户隐藏微信登录按钮，只提供其他登录方式（比如手机号注册登录、游客登录等）。*

  ![iphone](https://raw.githubusercontent.com/starboychina/WechatKit/master/demo/iphone.png)

  ![ipad](https://raw.githubusercontent.com/starboychina/WechatKit/master/demo/ipad.png)

- 获取微信用户信息

```swift
  WechatManager.shared.getUserInfo { result in
      switch result {
      case .failure(let errCode)://获取失败
          print(errCode)
      case .success(let value)://获取成功 value为([String: String]) 微信用户基本信息
          print(value) //当前是在子线程，如需回到主线程调用 DispatchQueue.main.async { print(value) }
      }
  }
```
- 退出登录

    由于默认会记住openid,以及access_token,如需要切换用户则需要退出登录.

```swift
WechatManager.shared.logout()
```

---

- 分享到微信

```swift
  WechatManager.shared.shareDelegate = self
  /**
  分享

  - parameter scence:      请求发送场景
  - parameter image:       消息缩略图
  - parameter title:       标题
  - parameter description: 描述内容
  - parameter url:         地址
  - parameter extInfo:     app分享信息(点击分享内容返回程序时,会传给WechatManagerShareDelegate.showMessage(message: String)
  */
  WechatManager.shared.share(scence: WXScene, image: UIImage?, title: String, description: String, url: String? = default, extInfo: String? = default)
```

- Delegation

[分享Delegation](https://github.com/starboychina/WechatKit/blob/master/WechatKit/WechatManagerShareDelegate.swift)

```swift
    //app分享后 点击分享返回时调用
    func showMessage(message: String)
```
