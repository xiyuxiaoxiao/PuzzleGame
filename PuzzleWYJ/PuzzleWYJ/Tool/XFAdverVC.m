//
//  XFAdverVC.m
//  PuzzleWYJ
//
//  Created by ZSXJ on 2017/1/20.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import "XFAdverVC.h"
#import "IFLYBannerAd.h"
@interface XFAdverVC ()<IFLYBannerAdDelegate>
@property (nonatomic, strong) IFLYBannerAd *banner;
@end

@implementation XFAdverVC

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initBanner];
    
    //添加后台判断 是否允许提那家广告
    [self isAllowAdver];
}

-(void)isAllowAdver {
    [WYJHTTPSession getAdverAllowSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        //成功
        NSInteger count = [[responseObject objectForKey:@"count"] integerValue];
        if (count >= 1) {
            //添加相关通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAdver) name:LocalLoopNotificationKey object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutNoti) name:LoginOutNotificationKey object:nil];
            
            //添加广告
            LocalLoopNoti *localLoopNoti = [LocalLoopNoti sharedInstance];
            [localLoopNoti startDetecting];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *theError) {
        //失败
    }];
}

-(void)initBanner {
    self.banner = [[IFLYBannerAd alloc]initWithOrigin:CGPointMake(0, 0)];
    self.banner.bannerAdDelegate = self;
    self.banner.currentViewController = self;
    [self.view addSubview:[self.banner getAdview]];
}

- (void)requestAdver{
    //请求广告
    [self.banner loadAdWithAdUnitId:@"60DD9EEBC1717A38D84021906614D97B" AndAppId:@"587ee4b2"];
}


#pragma mark IFLYBannerAdDelegate DelegateMethod
- (void) bannerAdReceive:(IFLYBannerAd *)banner{
    NSLog(@"成功了");
    [self.view addSubview:[banner getAdview]];
    [self showBottom];
}
- (void) bannerAdFailedByErrorCode:(AdError *)errorCode ByBanner:(IFLYBannerAd *)banner{
    NSLog(@"错误");
}
- (void) bannerAdClosed:(IFLYBannerAd *)banner{
    NSLog(@"关闭");
}
- (void) bannerAdClicked:(IFLYBannerAd *)banner{
    NSLog(@"点击了");
    [self hidBottom];
}

-(void)hidBottom{
    CGFloat y = [UIScreen mainScreen].bounds.size.height;
    CGFloat w = self.view.frame.size.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, y, w, 0);
    }];
}

-(void)showBottom{
    UIView *Adview = [self.banner getAdview];
    CGFloat adViewH = Adview.frame.size.height;
    
    CGFloat y = [UIScreen mainScreen].bounds.size.height - adViewH;
    CGFloat w = self.view.frame.size.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, y, w, adViewH);
    }];
}

-(void)loginOutNoti {
    LocalLoopNoti *localLoopNoti = [LocalLoopNoti sharedInstance];
    [localLoopNoti stopDetect];
}

@end
