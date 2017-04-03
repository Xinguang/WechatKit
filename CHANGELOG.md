###### SDK1.7.7
- 增加SDK分享小程序
- 增加选择发票接口

###### SDK1.7.6
- 提高稳定性
- 修复mta崩溃
- 新增接口支持开发者关闭mta数据统计上报

###### SDK1.7.5
- 提高稳定性
- 加快registerApp接口启动速度

###### SDK1.7.4
- 更新支持iOS启用 ATS(App Transport Security)
- 需要在工程中链接CFNetwork.framework
- 在工程配置中的”Other Linker Flags”中加入”-Objc -all_load”

###### SDK1.7.3
- 增强稳定性，适配iOS10
- 修复小于32K的jpg格式缩略图设置失败的问题

###### SDK1.7.2
- 修复因CTTeleponyNetworkInfo引起的崩溃问题

###### SDK1.7.1
- 支持兼容ipv6(提升稳定性)
- xCode Version 7.3.1 (7D1014) 编译

###### SDK1.7
- 支持兼容ipv6
- 修复若干问题增强稳定性

###### SDK1.6.3
- xCode7.2 构建的sdk包。
- 请使用xCode7.2进行编译。
- 需要在Build Phases中Link  Security.framework
- 修复若干小问题。

###### SDK1.6.2
- xCode7.1 构建的sdk包
- 请使用xCode7.1进行编译

###### SDK1.6.1
- 修复armv7s下,bitcode可能编译不过
- 解决warning

###### SDK1.6
- iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。
受此影响，当你的应用在iOS 9中需要使用微信SDK的相关能力（分享、收藏、支付、登录等）时，需要在“Info.plist”里增加如下代码：

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>weixin</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

- 开发者需要在工程中链接上 CoreTelephony.framework
- 解决bitcode编译不过问题

###### SDK1.5
- 废弃safeSendReq:接口，使用sendReq:即可。
- 新增+(BOOL) sendAuthReq:(SendAuthReq*) req viewController : (UIViewController*) viewController delegate:(id<WXApiDelegate>) delegate;
支持未安装微信情况下Auth,具体见WXApi.h接口描述
- 微信开放平台新增了微信模块用户统计功能，便于开发者统计微信功能模块的用户使用和活跃情况。开发者需要在工程中链接上:SystemConfiguration.framework,libz.dylib,libsqlite3.0.dylib。
