//
//  YCWBStatusTimelineViewController.m
//  YYKitDemoCoding
//
//  Created by 超杨 on 16/1/18.
//  Copyright © 2016年 杨超. All rights reserved.
//

#import "YCWBStatusTimelineViewController.h"
#import "YYKit.h"
#import "YCTableView.h"
#import "YCWBStatusHelper.h"
#import "YCWBStatusLayout.h"
#import "YCFPSLabel.h"
#import "YCWBModel.h"
#import "WBStatusCell.h"

@interface YCWBStatusTimelineViewController () <UITableViewDelegate, UITableViewDataSource, WBStatusCellDelegate>
@property (nonatomic, strong) UITableView    *tableView;
/** 布局数组 */
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) YCFPSLabel     *fpsLabel;
@end

@implementation YCWBStatusTimelineViewController

- (instancetype)init {
    self = [super init];
    /** 初始化 */
    _tableView = [[YCTableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _layouts = @[].mutableCopy;
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /** 关闭导航栏自动调整内边距 */
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[YCWBStatusHelper imageNamed:@"toolbar_compose_highlighted"] style:UIBarButtonItemStylePlain target:self action:@selector(sendStatus)];
    rightBarButtonItem.tintColor = UIColorHex(fd8224);
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    /** 配置tableview */
    _tableView.frame = self.view.bounds;
    /** 调整tableview的内边距 */
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kWBCellBackgroundColor;
    /** 创建fps显示条 */
    _fpsLabel = [[YCFPSLabel alloc] init];
    /** 调用sizeToFit走sizeThatSize，设置固定宽高 */
    [_fpsLabel sizeToFit];
    
    
    _fpsLabel.bottom = self.view.height - kWBCellPadding;
    _fpsLabel.left = kWBCellPadding;
    _fpsLabel.alpha = 0;
    [self.view addSubview:_fpsLabel];
    
    /** 适配iOS6 */
    if (kSystemVersion < 7) {
        _fpsLabel.top -= 44;
        _tableView.top -= 64; // 7之前y是从20的位置算0
        _tableView.height += 20;
    }
    
    self.navigationController.view.userInteractionEnabled = NO;
    /** 加载loading框 */
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    /** 灰阶图 灰度分为256阶
        通常RGB图片可以转换为灰度图，一下其中任何一个都可以
     1.浮点算法：Gray=R*0.3+G*0.59+B*0.11
     2.整数方法：Gray=(R*30+G*59+B*11)/100
     3.移位方法：Gray =(R*76+G*151+B*28)>>8;
     4.平均值法：Gray=（R+G+B）/3;
     5.仅取绿色：Gray=G；
     通过任何一种求得 Gray，并将RGB(R,G,B)中的R,G,B三原色都用Gary替换，形成RGB(Gary,Gary,Gary)用它替换原来的RGB(R,G,B)就可以得到灰度图
     */
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    /** 异步加载 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 7; ++i) {
            NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"weibo_%d.json", i]];
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", json);
            WBTimelineItem *item = [WBTimelineItem modelWithJSON:data];
            for (WBStatus *status in item.statuses) {
                YCWBStatusLayout *layout = [[YCWBStatusLayout alloc] initWithStatus:status style:(WBLayoutStyleTimeline)];
                [_layouts addObject:layout];
            }
        }
        [_layouts addObjectsFromArray:_layouts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [NSString stringWithFormat:@"Weibo (loaded:%d)", (int)_layouts.count];
            [indicator stopAnimating];
            [indicator removeFromSuperview];
            /** 加载完成后允许屏幕交互 */
            self.navigationController.view.userInteractionEnabled = YES;
            [_tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - event response
#pragma mark - ControllerDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"YC";
    WBStatusCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WBStatusCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        cell.delegate = self;
    }
    /** 设置viewmodel */
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}
#pragma mark - ControllerDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCWBStatusLayout *layout = _layouts[indexPath.row];
    if (![layout isKindOfClass:[YCWBStatusLayout class]]) {
        return 0;
    } else {
        return layout.height;
    }
}
#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    /** 当发生那个滚动拖拽，让fps动画显示 */
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState) animations:^{
            _fpsLabel.alpha = 1;
        } completion:NULL];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    /** 结束拖拽时，且没有减速时隐藏（手动停止） */
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1.0 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 0;
        } completion:NULL];
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 0;
        } completion:NULL];
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:NULL];
    }
    return YES;
}
#pragma mark - CustomDelegate
#pragma mark - private methods
- (void)sendStatus {
    
}
#pragma mark - getter and setter
@end
