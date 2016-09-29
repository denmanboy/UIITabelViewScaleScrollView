//
//  ViewController.m
//  UIITabelViewScaleScrollView
//
//  Created by yanzhou on 2016/9/28.
//  Copyright © 2016年 sina. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+YZTopZoomScroll.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    scrollView.contentSize =  CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 200);
    scrollView.pagingEnabled = YES;
    scrollView.directionalLockEnabled  = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    
    UIImageView *view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    view1.tag = 1;
    view1.image =[UIImage imageNamed:@"picture_1.jpg"];

    UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width,0, [UIScreen mainScreen].bounds.size.width, 200)];
    view2.image =[ UIImage imageNamed:@"picture_2.jpg"];
    view2.tag = 2;
    
    [scrollView addSubview:view1];
    [scrollView addSubview:view2];
    self.tableView.dataSource = self;
    //设置上面滑动视图
    self.tableView.topScrollView = scrollView;
    //默认缩放试图
    self.tableView.zoomImageView =  view1;
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDataSource

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =  @(indexPath.row).stringValue;
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (![scrollView isKindOfClass:[UITableView class]]) {
        //获取要缩放的视图
        int off_x = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
        UIImageView *imageView =  [scrollView viewWithTag:off_x+1];
        self.tableView.zoomImageView =  imageView;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
