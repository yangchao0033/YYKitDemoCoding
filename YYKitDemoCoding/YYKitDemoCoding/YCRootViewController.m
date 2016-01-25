//
//  ViewController.m
//  YYKitDemoCoding
//
//  Created by 超杨 on 16/1/18.
//  Copyright © 2016年 杨超. All rights reserved.
//

#import "YCRootViewController.h"
#import "YYKit.h"


@interface YCRootViewController ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation YCRootViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"YYKit 实践";
    self.classNames = @[].mutableCopy;
    self.titles = @[].mutableCopy;
//    [self log];
    [self addCell:@"Feed List Demo" class:@"YCFeedListExample"];
    NSString *str = [UIDevice currentDevice].machineModel.copy;
    NSLog(@"%@", str);
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
#pragma mark - ControllerDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YC"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YC"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}
#pragma mark - ControllerDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = self.classNames[indexPath.row];
    Class classObj = NSClassFromString(className);
    if (classObj) {
        UIViewController *ctrl = classObj.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - CustomDelegate
#pragma mark - private methods
- (void)log {
    double dw = pow(1024.0, 2);
    printf("全部内存：%.2f MB\t已使用：%.2f MB\t空闲：%.2f MB\t活动的：%.2f MB\t不活动：%.2f MB\t 有限内存：%.2f MB\t可清除的:%.2f MB\n",
           [UIDevice currentDevice].memoryTotal / dw,
           [UIDevice currentDevice].memoryUsed / dw,
           [UIDevice currentDevice].memoryFree / dw,
           [UIDevice currentDevice].memoryActive / dw,
           [UIDevice currentDevice].memoryInactive / dw,
           [UIDevice currentDevice].memoryWired / dw,
           [UIDevice currentDevice].memoryPurgable / dw
           );
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self log];
    });
}
- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}
#pragma mark - getter and setter
@end
