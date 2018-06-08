//
//  WYJHTTPSession.m
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/9/30.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import "WYJHTTPSession.h"
#import <AFNetworkActivityIndicatorManager.h>

static NSString *serverURL = @"https://api.leancloud.cn/1.1/";

@interface WYJHTTPSession ()

@end

@implementation WYJHTTPSession

+(void)POST:(NSString *)actStr withSession: (NSString *)session ReqParams:(NSDictionary *)params success:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc {
    
    
    AFNetworkActivityIndicatorManager *indicatorManager = [AFNetworkActivityIndicatorManager sharedManager];
    indicatorManager.enabled = YES;
    [indicatorManager incrementActivityCount];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 设置网络请求超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 15.0F;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *postURL = [[NSString alloc] initWithFormat:@"%@%@", serverURL, actStr];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:APPId forHTTPHeaderField:@"X-LC-Id"];
    [manager.requestSerializer setValue:APPKey forHTTPHeaderField:@"X-LC-Key"];
    
    if (session) {
        [manager.requestSerializer setValue:session forHTTPHeaderField:@"X-LC-Session"];
    }
    
    NSDictionary *postData = params;
    [manager POST:postURL
    parameters:postData
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [indicatorManager decrementActivityCount];
           succBlc(task,responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [indicatorManager decrementActivityCount];
           failBlc(task,error);
       }];
}

+(void)GET:(NSString *)actStr ReqParams:(NSDictionary *)params success:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc {
    
    AFNetworkActivityIndicatorManager *indicatorManager = [AFNetworkActivityIndicatorManager sharedManager];
    indicatorManager.enabled = YES;
    [indicatorManager incrementActivityCount];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *postURL = [[NSString alloc] initWithFormat:@"%@%@", serverURL, actStr];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:APPId forHTTPHeaderField:@"X-LC-Id"];
    [manager.requestSerializer setValue:APPKey forHTTPHeaderField:@"X-LC-Key"];
    
    NSDictionary *postData = params;
    
    [manager GET:postURL
       parameters:postData
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              [indicatorManager decrementActivityCount];
              succBlc(task,responseObject);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [indicatorManager decrementActivityCount];
              failBlc(task,error);
          }];
}


+(void)getLevelUrlWithLevelCount: (NSInteger)number success:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc{
    NSInteger level = number;
    
    NSString *act = @"classes/Level";
    NSDictionary *jsonDictionary = @{
                                     @"levelNumber":@(level),
                                     };
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    
    if (!jsonData) {
        NSLog(@"NSJSONSerialization failed %@", error);
    }
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                json, @"where", nil];
    [self GET:act ReqParams:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        succBlc(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *theError) {
        failBlc(task,theError);
    }];
}

#pragma mark - 请求是否允许添加广告 之所以设置在控制器中 主要是因为
+(void)getAdverAllowSuccess:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc{

    NSString *act = @"classes/Adver";
    NSDictionary *parameters = @{@"count":@(1)};
    [self GET:act ReqParams:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        succBlc(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *theError) {
        failBlc(task,theError);
    }];
}

@end
