//
//  WYJHTTPSession.h
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/9/30.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^SuccessBlock) (NSURLSessionDataTask *task,id responseObject);
typedef void (^FailedBlcok) (NSURLSessionDataTask *task,NSError*theError);
typedef void (^NetworkChangeBlock) (AFNetworkReachabilityStatus status);
typedef void (^MonitorProgressBlock) (NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);

@interface WYJHTTPSession : AFHTTPSessionManager

+(void)POST:(NSString *)actStr withSession: (NSString *)session ReqParams:(NSDictionary *)params success:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc;
+(void)GET:(NSString *)actStr ReqParams:(NSDictionary *)params success:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc;
+ (void)getLevelUrlWithLevelCount: (NSInteger)number success:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc;
+(void)updateUserLevelCount:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc;


+(void)getAdverAllowSuccess:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc;
@end
