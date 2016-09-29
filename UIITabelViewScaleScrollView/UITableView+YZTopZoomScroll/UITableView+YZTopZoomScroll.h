//
//  UIScrollView+YZTopZoomScroll.h
//  UIITabelViewScaleScrollView
//
//  Created by yanzhou on 2016/9/28.
//  Copyright © 2016年 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (YZTopZoomScroll)
//顶部试图滑动试图
@property(nonatomic,strong)UIScrollView *topScrollView;
//tableView 滑动时要缩放的试图
@property(nonatomic,weak) UIImageView *zoomImageView;
@end
