//
//  YCFeedListExample.m
//  YYKitDemoCoding
//
//  Created by 超杨 on 16/1/18.
//  Copyright © 2016年 杨超. All rights reserved.
//

#import "YCFeedListExample.h"
#import "YCWBStatusTimelineViewController.h"
#import "YYKit.h"

static const CGFloat kRowHeight = 48.0f;

@interface YCFeedListExample ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation YCFeedListExample

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    self.images = @[].mutableCopy;
    [self addCell:@"Twitter" class:@"T1HomeTimeLineItemsViewController" image:@"Twitter.jpg"];
    [self addCell:@"WeiBo" class:[YCWBStatusTimelineViewController className] image:@"Weibo.jpg"];
    self.tableView.rowHeight = kRowHeight;
    /** ios7之前适配，需要自己添加返回按钮导航 */
    if (!kiOS7Later) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    }
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"FEED LIST DEMO";
    
}
#pragma mark - event response
#pragma mark - ControllerDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YC"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"YC"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.imageView.image = _images[indexPath.row];
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = kRowHeight / 2;
    return cell;
}
#pragma mark - ControllerDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = _classNames[indexPath.row];
    Class classObj = NSClassFromString(className);
    if (classObj) {
        UIViewController *ctrl = [[classObj alloc] init];
        ctrl.title = _titles[indexPath.row];
        self.title = @" ";
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - CustomDelegate
#pragma mark - private methods
- (void)addCell:(NSString *)title class:(NSString *)className image:(NSString *)imageName {
    [self.titles addObject:title];
    [self.classNames addObject:className];
    [self.images addObject:[YYImage imageNamed:imageName]];
}
#pragma mark - getter and setter
@end
