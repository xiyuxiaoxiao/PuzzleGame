//
//  IFLYBannerAd.h
//  AD_Test
//
//  Created by cheng ping on 13-09-10.
//  Copyright (c) 2014年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFLYAdLog : NSObject

+ (void)debug:(NSString *)message;

+ (void)setDebugEnabled:(BOOL)enabled;

@end
