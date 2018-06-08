//
//  UIImage+GifLoad.h
//  PuzzleWYJ
//
//  Created by ZSXJ on 2016/12/14.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GifLoad)
+(UIImage *)imageGifWithName:(NSString *)name;
+ (UIImage *)image_animatedGIFWithData:(NSData *)data;
@end
