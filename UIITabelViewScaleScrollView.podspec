#
#  Be sure to run `pod spec lint YZDisplayViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "UIITabelViewScaleScrollView"
  s.version      = "1.1"
  s.summary      = "一行代码给tableView添加头部缩放滑动视图 "
  s.homepage     = "https://github.com/denmanboy"
  s.license      = "MIT"
  s.author       = { "denman" => "773557411@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/denmanboy/UIITabelViewScaleScrollView.git", :tag => "1.1" }
  s.requires_arc = true  
  s.source_files =  "UIITabelViewScaleScrollView/UITableView+YZTopZoomScroll/*.{h,m}"

  s.framework  = "UIKit"

end
