//
//  AppDelegate.m
//  YYKitDemoCoding
//
//  Created by 超杨 on 16/1/18.
//  Copyright © 2016年 杨超. All rights reserved.
//

#import "YCAppDelegate.h"
#import "YCRootViewController.h"
/** 自定义导航条便于版本适配 */
@interface YCExampleNavBar : UINavigationBar
@end

@implementation YCExampleNavBar{
    CGSize _previousSize;
}

/** 适配不同导航栏状态 */
- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:size];
    /** 如果状态栏影藏，导航条高为64 */
    if ([UIApplication sharedApplication].statusBarHidden) {
        size.height = 64;
    }
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /** 一旦发现当前的尺寸与之前的尺寸不一致，则在这个方法中做出调整 */
    if (!CGSizeEqualToSize(self.bounds.size, _previousSize)) {
        _previousSize = self.bounds.size;
        /** 如果前后尺寸不一致，则移除所有导航条上的动画 */
        [self.layer removeAllAnimations];
        [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
            [layer removeAllAnimations];
        }];
    }
}

@end

/** 定义例子导航栏 */
@interface YCExampleNavController : UINavigationController
@end
@implementation YCExampleNavController

/** 设置当前控制器的view是否自动旋转
    此处我们设置为旋转，其实默认就是旋转，这里的代码是为了适配ios5，因为ios5默认为不旋转。
 */
- (BOOL)shouldAutorotate {
    return YES;
}

/** 控制模态 且 根控制器 的旋转方向 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

/** 控制器 非跟控制器且模态控制器的旋转方向 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


@end



@interface YCAppDelegate ()

@end

@implementation YCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    YCRootViewController *root1 = [[YCRootViewController alloc] init];
    
    YCExampleNavController *nav1 = [[YCExampleNavController alloc] initWithNavigationBarClass:[YCExampleNavBar class] toolbarClass:[UIToolbar class]];
    
    /** 防止崩溃 */
    if ([nav1 respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        /** 设置不能使用导航栏或者toolbar或者tabbar 去调整scrollView的内边距，即设置这些为手动控制 */
        nav1.automaticallyAdjustsScrollViewInsets = NO;
    }
    [nav1 pushViewController:root1 animated:YES];
    
    self.rootViewController = nav1;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.rootViewController;
    self.window.backgroundColor = [UIColor grayColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
