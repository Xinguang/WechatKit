Pod::Spec.new do |s|
  s.name             = "WechatKit"
  s.version          = "0.1.4"
  s.summary          = "一款快速实现微信第三方登录的框架(Swift版)"
  s.homepage         = "https://github.com/starboychina/WechatKit"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "starboychina" => "wechatkit.github.com@kansea.com" }
  s.source           = { :git => "https://github.com/starboychina/WechatKit.git", :tag => s.version.to_s }
  s.documentation_url = 'http://starboychina.github.io/WechatKit/index.html'
  s.platform         = :ios, '8.0'
  s.requires_arc     = true

  s.source_files     = 'SDKExport/*.h',  'WechatKit/*'
  s.vendored_libraries  = 'SDKExport/libWeChatSDK.a'
  s.public_header_files = 'WechatKit/*.h', 'SDKExport/*.h'

  s.frameworks = 'SystemConfiguration', 'CoreTelephony'
  s.libraries = 'z', 'c++', 'sqlite3.0'
  s.dependency 'Alamofire', '~> 3.0'
end
