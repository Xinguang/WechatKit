#WechatKit
---
##Carthage
- 安装Carthage

```bash
$ brew update
$ brew install carthage
```

- 在项目根目录下创建Cartfile添加以下内容
```ogdl
github "starboychina/WechatKit"
```
- 执行carthage update

    切换到项目目录执行
```bash
$ carthage update --platform ios
```

- 在项目的Target -> Build Phases 中点击“+” -> New Run Script Phase

> 添加脚本

```bash
/usr/local/bin/carthage copy-frameworks
```

> 添加"Input Files"

```ogdl
$(SRCROOT)/Carthage/Build/iOS/Alamofire.framework
$(SRCROOT)/Carthage/Build/iOS/WechatKit.framework
```
- 在项目的Target -> Build Settings -> Framework Search Paths 輸入:
```ogdl
$(SRCROOT)/Carthage/Build/iOS
```
-
