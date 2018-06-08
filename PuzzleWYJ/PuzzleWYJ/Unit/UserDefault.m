//
//  UserDefault.m
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/9/30.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import "UserDefault.h"

#define SessionKey @"session"
#define UserName @"username"
#define Password @"password"

#define LevelURL @"level_url"
#define UserId   @"userId"
#define UserLeveInfoId   @"userLeveInfoId"
#define PermissionKey    @"permission"

@implementation UserDefault


+(void)setUserName: (NSString *)name {
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:UserName];
}
+(NSString *)getUserName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:UserName];
}

+(void)setPassword: (NSString *)pw {
    [[NSUserDefaults standardUserDefaults] setObject:pw forKey:Password];
}
+(NSString *)getPassword {
    return [[NSUserDefaults standardUserDefaults] stringForKey:Password];
}

#pragma mark - 获取权限
+(BOOL)getPermission {
    NSInteger permission = [[[AVUser currentUser] objectForKey:PermissionKey] integerValue];
    if (permission == 1) {
        return YES;
    }
    return NO;
}

@end
