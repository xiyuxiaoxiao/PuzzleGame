//
//  AppDelegate.m
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/9/30.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import "AppDelegate.h"
#import "RootVC.h"
#import "LoginVC.h"
@class RootVC;
@class LoginVC;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [application setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    
    [AVOSCloud setApplicationId:APPId clientKey:APPKey];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LoginSuccessNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:LoginOutNotificationKey object:nil];
    
    NSString *userid = [AVUser currentUser].objectId;
    NSLog(@"%@",userid);
    if ([AVUser currentUser]) {
        RootVC *vc = [[RootVC alloc] init];
        self.window.rootViewController = vc;
    }else {
        self.window.rootViewController = [[LoginVC alloc] init];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageGifWithName:@"xuehua"];
    imageView.backgroundColor = [UIColor colorWithRed:236/255.0 green:255/255.0 blue:228/255.0 alpha:1];
    imageView.alpha = 1;
    
    [self.window insertSubview:imageView atIndex:0];
    return YES;
}

-(void)loginSuccess {
    
    RootVC *vc = [[RootVC alloc] init];
    self.window.rootViewController = vc;
}

-(void)loginOut {
    self.window.rootViewController = [[LoginVC alloc] init];
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
