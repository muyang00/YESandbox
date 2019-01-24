# YESandbox


制作方法

1.写好代码，上传到github
     //github上创建项目仓库的时候记得创建LICENSE(许可证/授权)文件,此文件必须要有      

2.创建.podspec
    cd到你项目的目录,执行命令

  pod spec create YESandbox
  
3.编辑.podspec
  看最下面的podspec文件


4.验证.podspec
    到此检查一下你工程中有以下文件：

    .podspec文件,       LICENSE文件
    

pod spec lint YESandbox.podspec --verbose
     如果验证podspec有错误，修改完，把本地的文件推到远端上。
     
5.trunk需要CocoaPods

pod trunk me
    若未注册，执行以下命令，邮箱以及用户名请对号入座。用户名我使用的是Github上的用户名。

 // 加上--verbose可以输出详细错误信息，方便出错时查看。
      
pod trunk register example@example.com 'YESandbox'  --verbose
     注册完成之后会给你的邮箱发个邮件,进入邮箱邮件里面有个链接,需要点击确认一下。

    注册完成后使用pod trunk me检验注册是否成功


6.将自己的项目打成tag

       因为cocoapods是依赖tag版本的,所以必须打tag,以后再次更新只需要把你的项目打一个tag，然后修改.podspec文件中的版本接着提交到cocoapods官方就可以了,提交命令请看下面

     在终端执行以下命令：为git打tag, 第一次需要在前面加一个v
     
     

git tag "1.0.0" 
      
git push --tags


7.发布


pod trunk push YESandbox.podspec

    时间较长，耐性等待，大概5-10分钟       ###8.测试自己的cocoapods

    这个时候使用pod search搜索的话会提示搜索不到，可以执行以下命令更新本地search_index.json文件

rm ~/Library/Caches/CocoaPods/search_index.json
    然后

pod search YESandbox


完整的命令

```
pod trunk register example@example.com 'YESandbox'  --verbose
pod trunk me
pod spec create YESandbox
 
//编辑 YESandbox.podspec
 
pod spec lint YESandbox.podspec
git tag "v1.0.0"
git push --tags
pod trunk push YESandbox.podspec 
rm ~/Library/Caches/CocoaPods/search_index.json
pod search YESandbox


```
 
解决一些坑
1.- ERROR | [iOS] file patterns: The `source_files` pattern did not match any file.

解决办法：检查你.podspec文件中s.source_files路径有没有填错

2.did not pass validation ,due to 1 wanrings (but you can use --allow-warnings to ignore them)

解决办法：在命令后面加--allow-warnings

3.- ERROR | [iOS] xcodebuild: Returned an unsuccessful exit code. You can use `--verbose` for more information.
- NOTE | [iOS] xcodebuild: xcodebuild: error: 'App.xcworkspace' does not exist.
解决办法：更新你的Cocoapods版本
 
4.- ERROR | xcodebuild:  /Users/zhanglinfeng/Library/Developer/Xcode/DerivedData/App-culgapkleglkstaqypgjlqqpywqh/Build/Products/Release-iphonesimulator/LFKit/LFKit.framework/Headers/LFEncryptDecryptUtil.h:10:9: error: include of non-modular header inside framework module 'LFKit.LFEncryptDecryptUtil': '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator11.0.sdk/usr/include/CommonCrypto/CommonCryptor.h' [-Werror,-Wnon-modular-include-in-framework-module]

解决办法：#import <CommonCrypto/CommonCryptor.h>从.h文件拿到.m文件。原因不明，反正我辛辛苦苦各种尝试，这样就解决了。

     

## podspec文件

```
Pod::Spec.new do |s|
s.name        = 'YESand'
s.version     = '1.0.1'
s.authors     = { 'muyang00' => '280798744@qq.com' }
s.homepage    = 'https://github.com/muyang00/YESand'
s.summary     = 'a dropdown menu for ios like save homepage.'
s.source      = { :git => 'https://github.com/muyang00/YESand.git',
:tag => s.version.to_s }
s.license     = { :type => "MIT", :file => "LICENSE" }


s.platform = :ios, '8.0'
s.requires_arc = true
s.source_files = 'YESand/YE.h'
s.public_header_files = 'YESand/YE.h'
s.ios.deployment_target = '8.0'


s.dependency 'SVProgressHUD'

  s.subspec 'B' do |ss|
   
    ss.source_files = 'YESand/B/**/*.{h,m}'
    ss.public_header_files = 'YESand/B/**/*.h'
    
  end

  s.subspec 'C' do |ss|
   
    ss.dependency 'YESand/B'

    ss.source_files = 'YESand/C/**/*.{h,m}'
    ss.public_header_files = 'YESand/C/**/*.h'
 
  end
end

```

到这里就全部结束了

![a](https://github.com/muyang00/YESandbox/blob/master/a.png)


