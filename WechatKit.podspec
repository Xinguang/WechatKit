Pod::Spec.new do |s|
  s.name             = "WechatKit"
  s.version          = "0.0.2"
  s.summary          = "一款快速实现微信认证的framework written in Swift"
  s.homepage         = "https://github.com/starboychina/WechatKit"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "starboychina" => "wechatkit.github.com@kansea.com" }
  s.source           = { :git => "https://github.com/starboychina/WechatKit.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SDKExport/*',  'WechatKit/*'
  s.vendored_libraries = 'SDKExport/libWeChatSDK.a'
  s.public_header_files = 'WechatKit/*.h', 'SDKExport/*.h'

  s.frameworks = 'SystemConfiguration', 'CoreTelephony'
  s.libraries = 'z', 'c++', 'sqlite3.0'
  s.dependency 'Alamofire', '~> 3.0'
end
