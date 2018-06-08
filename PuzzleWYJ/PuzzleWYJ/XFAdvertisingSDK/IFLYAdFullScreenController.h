//  IFLYAdFullScreenController.h
//
//
//  Created by cheng ping on 13-09-10.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdError.h"


@protocol IFLYFullScreenAdDelegate <NSObject>
/**
 *  请求全屏广告成功
 */
- (void) fullScreenAdReceive;
/**
 *  请求全屏广告错误
 *
 *  @param errorCode 错误码，详见入门手册
 */
- (void) fullScreenAdFailedByErrorCode:(AdError *)errorCode;
/**
 *  全屏广告关闭回调
 */
- (void) fullScreenAdClosed;
/**
 *  广告被点击
 */
- (void) fullScreenAdClicked;

@end


@interface IFLYAdFullScreenController : UIViewController<UIWebViewDelegate>
/**
 *  全屏广告代理
 */
@property ( nonatomic, weak ) id<IFLYFullScreenAdDelegate> fullScreenAdDelegate;
/**
 *  设置父控制器
 */
@property (nonatomic,strong) UIViewController *presentingController;
/**
 *  是否隐藏状态栏，默认隐藏
 */
@property(readwrite,nonatomic,assign) BOOL perferStatusBarHidden;

/**
 *  获取全屏对象
 *
 *  @return 返回IFLYAdFullScreenController
 */
+ (IFLYAdFullScreenController *) sharedInstance;
/**
 *  请求全屏广告
 *
 *  @param adUnitId 广告位
 *  @param appid    appid
 */
- (void) loadAdWithAdUnitId:(NSString *) adUnitId AndAppId:(NSString *) appid;
/**
 *  展示全屏广告
 *
 *  @param animated 是否允许动画
 */
- (void)showFullscreenBrowserAnimated:(BOOL)animated;
/**
 *  关闭全屏广告
 *
 *  @param animated 是否允许动画
 */
- (void)closeFullscreenBrowserAnimated:(BOOL)animated;
/**
 *  设置自动关闭时间，默认3000毫秒
 *
 *  @param time 自动关闭时间
 */
- (void)setDisplayTime:(int) time;

@end


