//
//  LocalLoopNoti.h
//  PuzzleWYJ
//
//  Created by ZSXJ on 2017/1/20.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalLoopNoti : NSObject

+(LocalLoopNoti *)sharedInstance;

- (void)startDetecting;
- (void)stopDetect;
@end
