//
//  IFLYNativeAd.h
//  AD_Demo
//
//  Created by chengping on 15/12/18.
//  Copyright © 2015年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdError.h"

extern NSString* const IFLYNativeAdDataKeyTitle;
extern NSString* const IFLYNativeAdDataKeySubTitle;
extern NSString* const IFLYNativeAdDataKeyIcon;
extern NSString* const IFLYNativeAdDataKeyImg;
extern NSString* const IFLYNativeAdDataKeyImgUrls;
extern NSString* const IFLYNativeAdDataKeySourceMark;

@interface IFLYNativeAdData : NSObject

/*
 *  广告内容字典
 *       广告数据以字典的形式存储，开发者目前可以通过如下键获取数据
 *          1. IFLYNativeAdDataKeyTitle          标题
 *          2. IFLYNativeAdDataKeySubTitle       描述
 *          3. IFLYNativeAdDataKeyIcon           图标Url
 *          4. IFLYNativeAdDataKeyImg            大图Url
 *          5. IFLYNativeAdDataKeyImgUrls        图片地址Urls
 *          6. IFLYNativeAdDataKeySourceMark     广告来源
 */
@property (nonatomic, retain) NSDictionary *properties;

- (void) setImprExposure;
- (BOOL) getImprExposure;

- (void) setClickExposure;
- (BOOL) getClickExposure;

@end





@class IFLYNativeAd;

@protocol IFLYNativeAdDelegate <NSObject>

/**
 *  原生广告加载广告数据成功回调，返回为IFLYNativeAdData对象的数组
 */
-(void)nativeAdReceived:(NSArray *)nativeAdDataArray;

/**
 *  原生广告加载广告数据失败回调
 */
-(void)nativeAdFailToLoad:(AdError *)error;



@end




@interface IFLYNativeAd : NSObject


/**
 *  委托对象
 */
@property (nonatomic, assign) id<IFLYNativeAdDelegate> delegate;
/**
 *  父视图
 *  需设置为显示广告的UIViewController
 */
@property (nonatomic, weak) UIViewController *currentViewController;

/**
 *  构造方法
 *  详解：appkey是应用id, placementId是广告位id
 */
-(instancetype)initWithAppId:(NSString *)appId adunitId:(NSString *)adunitId;

/**
 *  广告发起请求方法
 *  详解：[必选]发起拉取广告请求,在获得广告数据后回调delegate
 *  @param adCount 一次拉取广告的个数
 */
-(void)loadAd:(int)adCount;

/**
 *  广告数据渲染完毕即将展示时调用方法
 *  详解：[必选]广告数据渲染完毕，即将展示时需调用本方法。
 *      @param nativeAdData 广告渲染的数据对象
 *      @param view         渲染出的广告结果页面
 */
-(BOOL)attachAd:(IFLYNativeAdData *)nativeAdData toView:(UIView *)view;

/**
 *  广告点击调用方法
 *  详解：当用户点击广告时，开发者需调用本方法，系统会弹出内嵌浏览器、或内置AppStore、
 *      或打开系统Safari，来展现广告目标页面
 *      @param nativeAdData 用户点击的广告数据对象
 */
-(void)clickAd:(IFLYNativeAdData *)nativeAdData;


@end
