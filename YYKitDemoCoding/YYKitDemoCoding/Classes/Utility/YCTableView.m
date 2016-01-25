//
//  YCTableView.m
//  YYKitDemoCoding
//
//  Created by 超杨 on 16/1/18.
//  Copyright © 2016年 杨超. All rights reserved.
//

#import "YCTableView.h"

@implementation YCTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
//    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    /** 移除自从iOS8开始的触摸延迟 */
    UIView *wrapView = self.subviews.firstObject;
    /** UITableViewWrapperView */
    if (wrapView && [NSStringFromClass(wrapView.class) hasPrefix:@"WrapperView"]) {
        for (UIGestureRecognizer *ges in wrapView.gestureRecognizers) {
            /** UIScrollViewDelayedTouchBeganGestureRecognizer */
            if ([NSStringFromClass([ges class]) containsString:@"DelayedTouchesBegan"]) {
                ges.enabled = NO;
                break;
            }
        }
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    if ([view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}
@end

