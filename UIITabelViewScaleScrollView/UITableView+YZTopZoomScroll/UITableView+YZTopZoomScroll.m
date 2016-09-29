//
//  UIScrollView+YZTopZoomScroll.m
//  UIITabelViewScaleScrollView
//
//  Created by yanzhou on 2016/9/28.
//  Copyright © 2016年 sina. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+YZTopZoomScroll.h"

#define YZKeyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))

static char * const YZTableViewKey = "YZTableViewKey";
static char * const YZTopScrollViewKey = "YZTopScrollViewKey";
static char * const YZTopZoomImageViewKey = "YZTopZoomImageViewKey";
static char * const YZTopZoomImageViewFrameKey = "YZTopZoomImageViewFrameKey";


@interface YZHeaderView : UIView
@property(nonatomic,weak) UITableView *tableView;
@end
@implementation YZHeaderView

//触摸事件拦截
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint subPoint = [self convertPoint:point toView:self];
    if ([self pointInside:subPoint withEvent:event]) {
        [self.tableView.topScrollView hitTest:point withEvent:event];
    }else{
        [super hitTest:point withEvent:event];
    }
    return  nil;
}
- (void)setTableView:(UITableView *)tableView
{
    objc_setAssociatedObject(self, YZTableViewKey, tableView, OBJC_ASSOCIATION_ASSIGN);
}

- (UITableView *)tableView
{
    return  objc_getAssociatedObject(self, YZTableViewKey);
}
@end
@implementation UITableView (YZTopZoomScroll)

+ (void)load{
    [self yz_swizzleInstanceSelector:@selector(setTableHeaderView:) swizzleSelector:@selector(setYz_TableHeaderView:)];
}
+ (void)yz_swizzleInstanceSelector:(SEL)origSelector
                   swizzleSelector:(SEL)swizzleSelector {
    
    // 获取原有实例方法
    Method origMethod = class_getInstanceMethod(self,
                                                origSelector);
    // 获取交换实例方法
    Method swizzleMethod = class_getInstanceMethod(self,
                                                   swizzleSelector);
    BOOL isAdd = class_addMethod(self, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (!isAdd) { // 添加方法失败，表示原有方法存在，直接替换
        method_exchangeImplementations(origMethod, swizzleMethod);
    }else {
        //方法不存在，直接把自己方法的实现作为原有方法的实现，调用原有方法，就会来到当前方法的实现
        class_replaceMethod(self, swizzleSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
}
- (void)setTopScrollView:(UIScrollView *)topScrollView
{
    //删除原来的
    [self.topScrollView removeFromSuperview];
    //添加设置的
    CGRect frame =  topScrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    topScrollView.frame = frame;
    //不要裁剪子视图 因为子视图frame放大要超出父试图范围
    topScrollView.clipsToBounds = NO;
    //关联对象
    objc_setAssociatedObject(self,
                             YZTopScrollViewKey,
                             topScrollView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //添加视图
    [self insertSubview:topScrollView atIndex:0];
    //kvo 监听
    [self addObserver:self
           forKeyPath:YZKeyPath(self, contentOffset)
              options:NSKeyValueObservingOptionNew
              context:nil];
    //主动设置头部试图
    YZHeaderView *headerView = [[YZHeaderView alloc] initWithFrame:CGRectMake(0, 0, topScrollView.frame.size.width, topScrollView.frame.size.height)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.tableView = self;
    self.tableHeaderView = headerView ;
}

// 拦截通过代码设置tableView头部视图-防止用户再设置tableViewHeaderView
- (void)setYz_TableHeaderView:(UIView *)tableHeaderView
{
    if (self.tableHeaderView) {
        if (![self.tableHeaderView isKindOfClass:[YZHeaderView class]]) {
            [self setYz_TableHeaderView:tableHeaderView];
        }
    }else{
        [self setYz_TableHeaderView:tableHeaderView];
    }
}
- (UIScrollView *)topScrollView
{
    UIScrollView *scrollView  = objc_getAssociatedObject(self, YZTopScrollViewKey);
    return scrollView;
}
- (void)setZoomImageView:(UIImageView *)zoomImageView
{
    objc_setAssociatedObject(self,
                             YZTopZoomImageViewKey,
                             zoomImageView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self setZoomImageViewFrame:zoomImageView.frame];
}

- (UIImageView *)zoomImageView
{
    return objc_getAssociatedObject(self, YZTopZoomImageViewKey);
}
- (void)setZoomImageViewFrame:(CGRect)zoomImageViewFrame
{
    objc_setAssociatedObject(self, YZTopZoomImageViewFrameKey,
                             NSStringFromCGRect(zoomImageViewFrame),
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (CGRect)zoomImageViewFrame
{
    NSString *frameString = objc_getAssociatedObject(self, YZTopZoomImageViewFrameKey);
    return CGRectFromString(frameString);
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    // 获取当前偏移量
    CGFloat offsetY = self.contentOffset.y;
    if (offsetY < 0) {
        self.zoomImageView.frame = CGRectMake(offsetY + self.zoomImageViewFrame.origin.x, offsetY + self.zoomImageViewFrame.origin.y, self.bounds.size.width - 2 * offsetY, self.self.zoomImageViewFrame.size.height - offsetY);
    } else {
        self.zoomImageView.frame = self.zoomImageViewFrame;
    }
}
@end
