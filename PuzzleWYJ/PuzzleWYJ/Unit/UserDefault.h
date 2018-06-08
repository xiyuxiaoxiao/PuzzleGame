//
//  UserDefault.h
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/9/30.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Level @"level" //关卡数


@interface UserDefault : NSObject

+(void)setSession: (NSString *)session;
+(NSString *)getSession;

+(void)setUserName: (NSString *)name;
+(NSString *)getUserName;

+(void)setPassword: (NSString *)pw;
+(NSString *)getPassword;

+(void)setLevel: (NSString *)level;
+(NSString *)getLevel;

+(void)setLevelURL: (NSString *)levelURL;
+(NSString *)getLevelURL;

+(void)setUserId: (NSString *)userId;
+(NSString *)getUserId;

+(void)setUserLeveInfoId: (NSString *)str;
+(NSString *)getUserLeveInfoId;

#pragma mark - 获取权限
+(BOOL)getPermission;

@end
