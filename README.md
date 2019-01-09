## iOS Potatso源码（配置下自己的开发证书就能编译版本）,对你有帮助的话欢迎star
### 本着开源的精神。希望大家不要用做其他目的。得知有人想要发布到到appstore时，我很失望。。
### 参考链接 <https://github.com/JonyFang/Potatso>
### 参考链接 <https://github.com/haxpor/Potatso>
### 运行报错issues参考链接<https://github.com/haxpor/Potatso/issues/41>
### 修改下自己的appgroup的id（这一步很重要）

![](https://github.com/we11cheng/WCImageHost/raw/master/WX20190109-121447.png)

### group id如图所示
![](https://github.com/we11cheng/WCImageHost/raw/master/WX20180912-174728.png)

### 最终效果，亲测可用，不能用你来捶我！
![](https://github.com/we11cheng/WCImageHost/raw/master/WX20190109-122522.png)

![](https://github.com/we11cheng/WCImageHost/raw/master/Screen%20Shot%202019-01-09%20at%2012.35.09%20PM.png)

### 本人Xcode运行截图，Xcode版本：Version 9.2 (9C40b)，不是9.2版本可能会有其他错误。建议使用9.2版本。
![](https://github.com/we11cheng/WCImageHost/raw/master/WX20180723-100756.png)

### 2017-7-17 最新更新，配置了Person VPN & Network Extensions
![](https://github.com/we11cheng/WCImageHost/raw/master/WX20180717-171534.png)

### 无需```pod update --verbose --no-repo-update```，clone之后直接运行。个人主页有qq(微信同号)。可以一起学习交流。抱有其他目的就算了。
### iOS Widget Extensions证书配置 参考<https://github.com/we11cheng/WCStudy/blob/master/iOS%20Widget%20Extensions%E8%AF%81%E4%B9%A6%E9%85%8D%E7%BD%AE.md>
### 希望大家遵守开源精神，勿作他用。
### 默认的gitignore，已经去除了。代码可直接使用。
### 2018-9-14 根据<https://github.com/we11cheng/iShadowsocksR>,fork大佬的项目，编译成功,百度网盘地址链接: <https://pan.baidu.com/s/1rX6e14jRY4xmM1NT5r9tPw> 密码: r3pv,需要可以自取。
```
.DS_Store

# C extensions
*.so

# Unit test / coverage reports
htmlcov/
.tox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*,cover
.idea/


# iOS
# Xcode
#
build/
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata
*.xccheckout
*.moved-aside
DerivedData
*.hmap
*.ipa
*.xcuserstate
xcshareddata/**
Potatso.xcworkspace/xcshareddata/

# CocoaPods
#
# We recommend against adding the Pods directory to your .gitignore. However
# you should judge for yourself, the pros and cons are mentioned at:
# http://guides.cocoapods.org/using/using-cocoapods.html#should-i-ignore-the-pods-directory-in-source-control
#
#Pods/
# Add Podfile.lock for future maintenance reason
#Podfile.lock

# Carthage
#Carthage/Build


# fastlane
#fastlane

Gemfile.lock

#Confidential/
#Confidential.h

```



