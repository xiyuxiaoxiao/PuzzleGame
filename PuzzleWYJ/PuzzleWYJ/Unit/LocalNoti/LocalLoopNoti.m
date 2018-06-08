//
//  LocalLoopNoti.m
//  PuzzleWYJ
//
//  Created by ZSXJ on 2017/1/20.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import "LocalLoopNoti.h"

@interface LocalLoopNoti ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LocalLoopNoti

+(LocalLoopNoti *)sharedInstance {
    static LocalLoopNoti *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[LocalLoopNoti alloc] init];
    });
    
    return shareManager;
}

- (NSTimer *)timer {
    if (!_timer) {
        
        _timer =  [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    }
    return _timer;
}


-(void)timerMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:LocalLoopNotificationKey object:nil];
}

- (void)startDetecting {
    [self.timer fire];
}
- (void)stopDetect {
    [self.timer invalidate];
    self.timer = nil;
}

@end
