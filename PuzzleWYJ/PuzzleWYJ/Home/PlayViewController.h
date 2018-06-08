//
//  PlayViewController.h
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/10/10.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlayFinished)(void);

@interface PlayViewController : UIViewController
@property (nonatomic,copy)PlayFinished finishedBlock;

@property (nonatomic,strong)Photo *photo;
@property (nonatomic,strong)UIImage *image;//原始image
@property (nonatomic,strong)UIImage *puzzleImage;
@end
