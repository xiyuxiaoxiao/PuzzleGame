//
//  IFLYBannerAd.h
//  AD_Test
//
//  Created by cheng ping on 14/10/20.
//  Copyright (c) 2014年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdError.h"
@class IFLYBannerAd;

@protocol IFLYBannerAdDelegate <NSObject>
/**
 *  请求横幅广告成功
 */
- (void) bannerAdReceive:(IFLYBannerAd *)banner;
/**
 *  请求横幅广告错误
 *
 *  @param errorCode 错误码，详见入门手册
 */
- (void) bannerAdFailedByErrorCode:(AdError *)errorCode ByBanner:(IFLYBannerAd *)banner;
/**
 *  横幅广告关闭回调
 */
- (void) bannerAdClosed:(IFLYBannerAd *)banner;
/**
 *  广告被点击
 */
- (void) bannerAdClicked:(IFLYBannerAd *)banner;

@end

@interface IFLYBannerAd : NSObject 
/**
 *  横幅广告代理
 */
@property ( nonatomic, weak ) id<IFLYBannerAdDelegate> bannerAdDelegate;
/**
 *  父视图
 *  需设置为显示广告的UIViewController
 */
@property (nonatomic, weak) UIViewController *currentViewController;
/**
 *  设置横幅广告位置
 *
 *  @param origin 横幅广告坐标点
 *
 *  @return 返回横幅广告对象
 */
- (id) initWithOrigin:(CGPoint)origin;
/**
 *  获取横幅view
 *
 *  @return 返回横幅view
 */
- (UIView *) getAdview;
/**
 *  请求横幅广告
 *
 *  @param adUnitId 广告位
 *  @param appid    appid
 *  @param autoRequest    是否轮播 (如需聚合讯飞SDK，请设置为NO)
 */
- (void) loadAdWithAdUnitId:(NSString *) adUnitId AndAppId:(NSString *) appid IsAutoRequest:(BOOL) autoRequest;
/**
 *  请求横幅广告
 *
 *  @param adUnitId 广告位
 *  @param appid    appid
 */
- (void) loadAdWithAdUnitId:(NSString *) adUnitId AndAppId:(NSString *) appid;
/**
 *  清除广告
 */
- (void) destroy;
@end
