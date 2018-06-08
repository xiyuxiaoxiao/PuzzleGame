//
//  PlayViewController.m
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/10/10.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import "PlayViewController.h"

#define JigsawPuzzleSucceedNotificationKey @"JigsawPuzzleSucceedNotificationKey"

@interface PlayViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;// 用于拼图成功后，但是请求服务器关卡数据更新失败，来再次更新的

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthLayout;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(puzzleSucceed) name:JigsawPuzzleSucceedNotificationKey object:nil];
    
    self.view.backgroundColor = RootViewBackColor;
    
    CGRect frame = [JigsawPuzzleView viewFrame];
    self.imageViewWidthLayout.constant = frame.size.width;
    self.imageViewHeightLayout.constant = frame.size.width;
    
    
    self.imageView.image = self.puzzleImage;
    [self add];
    
    self.finishedButton.alpha = 0;
    self.finishedButton.layer.cornerRadius = 20;
    self.finishedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:36/255.0 alpha:1];
    
    UIImage *backImage = [UIImage imageNamed:@"backArrow"];
    backImage = [backImage imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    self.backButton.tintColor = [UIColor whiteColor];
    self.backButton.layer.cornerRadius = 10;
    self.backButton.backgroundColor = [UIColor lightGrayColor];
    [self.backButton setImage:backImage forState:(UIControlStateNormal)];
    
    self.restartButton.tintColor = [UIColor whiteColor];
    UIImage *restartImage = [[UIImage imageNamed:@"restartOpen"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    [self.restartButton setImage:restartImage forState:(UIControlStateNormal)];

}

-(void)puzzleSucceed {
    self.restartButton.alpha = 0;
    self.imageView.image = self.image;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"恭喜您 成功进入下一关";
    self.hud.mode = MBProgressHUDModeText;
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.dimBackground = NO;
    
    AVUser *currentUser = [AVUser currentUser];
    NSInteger level = [[currentUser objectForKey:@"level"] integerValue];
    [currentUser setObject:@(level + 1) forKey:@"level"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        self.finishedBlock();
        // 无论成功 与否 本地都保存了
        [self.hud hide:YES afterDelay:0.8];
        [self performSelector:@selector(back) withObject:nil afterDelay:2];
    }];
}

- (IBAction)outAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)finished:(id)sender {
    // 换一换方式
}

//重新开始  不能有这个按钮
- (IBAction)restartAction:(id)sender {
    [self add];
}

-(void)add {
    [JigsawPuzzleView addJigsawPuzzleView:self image:self.image photo:self.photo];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
