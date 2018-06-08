//
//  IFLYAdBootViewController.h
//  
//
//  Created by cheng ping on 14/10/20.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdError.h"

@protocol IFLYAdBootScreenAdDelegate <NSObject>
/**
 *  请求开屏广告成功
 */
- (void) bootScreenAdSuccess;
/**
 *  请求开屏广告错误
 *
 *  @param errorCode 错误码，详见入门手册
 */
- (void) bootScreenAdFailedByErrorCode:(AdError *)errorCode;
/**
 *  开屏广告关闭回调
 */
- (void) bootScreenAdClosed;
/**
 *  广告被点击
 */
- (void) bootScreenAdClicked;

@end

@interface IFLYAdBootViewController : UIViewController
/**
 *  开屏广告代理
 */
@property ( nonatomic, weak ) id<IFLYAdBootScreenAdDelegate> bootScreenAdDelegate;
/**
 *  设置父控制器
 */
@property (nonatomic,strong) UIViewController *presentingController;
/**
 *  是否隐藏状态栏，默认隐藏
 */
@property(readwrite,nonatomic,assign) BOOL perferStatusBarHidden;
/**
 *  获取开屏对象
 *
 *  @return 返回IFLYAdFullScreenController
 */
+ (IFLYAdBootViewController *) sharedInstance;
/**
 *  请求开屏广告
 *
 *  @param adUnitId 广告位
 *  @param appid    appid
 */
- (void) loadAdWithAdUnitId:(NSString *) adUnitId AndAppId:(NSString *) appid;
/**
 *  展示开屏广告
 *
 *  @param animated 是否允许动画
 */
- (void)showBootScreenBrowserAnimated:(BOOL)animated;
/**
 *  关闭开屏广告
 *
 *  @param animated 是否允许动画
 */
- (void)closeBootScreenBrowserAnimated:(BOOL)animated;

@end
