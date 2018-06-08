//
//  RootVC.m
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/9/30.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import "RootVC.h"
#import "PlayViewController.h"
#import "XFAdverVC.h"

@interface RootVC ()

//{
//    NSInteger row;
//    NSInteger column;
//}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;

@property (weak, nonatomic) IBOutlet UILabel *levelCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *startPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *resetLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *changeArrayButton;
@property (weak, nonatomic) IBOutlet UIButton *loginOutButton;


@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic,strong)Photo *photo;
@property (nonatomic,strong)UIImage *image;//原始image

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthLayout;


@property (assign, nonatomic)NSInteger row;
@property (assign, nonatomic)NSInteger column;

@property (nonatomic, strong) XFAdverVC *xfadverVC;
@end

@implementation RootVC

-(NSInteger)row {
    if (_row < 3) {
        return 3;
    }
    return _row;
}

-(NSInteger)column {
    if (_column < 3) {
        return 3;
    }
    return _column;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RootViewBackColor;
    
    self.startPlayButton.layer.cornerRadius = 20;
    
    self.resetLevelButton.layer.cornerRadius = 10;
    self.loginOutButton.layer.cornerRadius = 10.5;
    self.changeArrayButton.layer.cornerRadius  = 15;
    
    NSInteger level = [[[AVUser currentUser] objectForKey:@"level"] integerValue];
    self.levelCountLabel.text = [NSString stringWithFormat:@"关卡数%ld",level];
    
    [self reload:NO];
    
    
    CGRect frame = [JigsawPuzzleView viewFrame];
    self.imageView.frame = frame;
    self.imageViewWidthLayout.constant = frame.size.width;
    self.imageViewHeightLayout.constant = frame.size.width;
    [self.view setNeedsDisplay];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.xfadverVC == nil) {
        
    }
    self.xfadverVC = [[XFAdverVC alloc] init];
    [self addChildViewController:self.xfadverVC];
    self.xfadverVC.view.frame = CGRectMake(0, self.view.bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
    [self.view addSubview:self.xfadverVC.view];
}

- (IBAction)loginOut:(UIButton *)sender {
    [AVUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginOutNotificationKey object:nil];
}

- (IBAction)startPlayGame:(id)sender {
//    
//    if () {
//        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        self.hud.mode = MBProgressHUDModeText;
//        
//        self.hud.yOffset = -150.f;
//        self.hud.labelText = @"数据还没有准备好";
//        self.hud.removeFromSuperViewOnHide = YES;
//        self.hud.dimBackground = NO;
//        [self.hud hide:YES afterDelay:1];
//        
//        return;
//    }
    
    PlayViewController *vc = [[PlayViewController alloc] init];
    vc.photo = self.photo;
    vc.image = self.image;
    vc.puzzleImage = self.imageView.image;
    vc.finishedBlock = ^(void){
        [self reload:NO];
    };
    [self presentViewController:vc animated:nil completion:nil];
}

//获取相应关卡的url
-(void)reload: (BOOL)needHud {

    [self setStartPlayButtonEnabled:NO];
    // 在获取失败的情况下 不至于显示之前的关卡的图片
    self.imageView.image = [UIImage imageNamed:@"puzzleDefault"];
    if (needHud) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    self.hud.labelText = @"加载中";
        self.hud.removeFromSuperViewOnHide = YES;
        self.hud.dimBackground = NO;
    }
    
    AVUser *currentUser = [AVUser currentUser];
    NSInteger level = [[currentUser objectForKey:@"level"] integerValue];
    self.levelCountLabel.text = [NSString stringWithFormat:@"关卡数%ld",(long)level];
    
    if (level > 1) {
        self.resetLevelButton.alpha = 1;
    }else {
        self.resetLevelButton.alpha = 0;
    }
    
    [WYJHTTPSession getLevelUrlWithLevelCount:level success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (needHud) {
            [self.hud hide:YES];
        }
        
        NSArray *array = [responseObject objectForKey:@"results"];
        if (array.count == 1) {
            NSDictionary *dict = array[0];
            
            _row = [[dict objectForKey:@"row"] integerValue];
            _column = [[dict objectForKey:@"column"] integerValue];
            
            NSString *url = [dict objectForKey:@"url"];
            [self setImageViewWIthUrl:url];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *theError) {
        if (needHud) {
            [self.hud hide:YES];
        }
        // 当失败的时候 再次请求数据，相当于遍历
        [self reload:NO];
    }];
}

-(void)setImageViewWIthUrl: (NSString *)url {
    
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"puzzleDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
/*
         if (cacheType != SDImageCacheTypeMemory) {
             // 不能使用uiview.animation 否则在渐变的时候，不能滑动
             [UIView beginAnimations:@"Fadein" context:nil];
             [UIView setAnimationCurve:0.8];
             self.imageView.alpha = 0;
             self.imageView.alpha = 1;
             [UIView commitAnimations];
         }
*/
        if(error == nil) {
            Photo *photo = [[Photo alloc] init];
            photo.imageURL = url;
            
            JigsawPuzzlePhoto *jigsawPuzzle = [[JigsawPuzzlePhoto alloc] init];
            jigsawPuzzle.row = @(self.row);
            jigsawPuzzle.column = @(self.column);
            PuzzleManage *pm = [[PuzzleManage alloc] init];
            jigsawPuzzle.numberArray = [pm getRandomNumbersArray:self.row*self.column];
            
            photo.jigsawPuzzle = jigsawPuzzle;
            
            CGSize size = self.imageView.bounds.size;
            [PuzzleManage puzzleImageView:self.imageView image:image size:size photo:photo];
            
            self.image = image;
            self.photo = photo;
            
            [self setStartPlayButtonEnabled:YES];
        }
    }];
}

//切换排列方式
- (IBAction)changeArrange:(UIButton *)sender {
    PuzzleManage *pm = [[PuzzleManage alloc] init];
    self.photo.jigsawPuzzle.numberArray = [pm getRandomNumbersArray:self.row*self.column];
    CGSize size = self.imageView.bounds.size;
    [PuzzleManage puzzleImageView:self.imageView image:self.image size:size photo:self.photo];
}

-(void)setStartPlayButtonEnabled: (BOOL)enable {
    self.startPlayButton.enabled = enable;
    
    if (enable) {
        
        self.startPlayButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:36/255.0 alpha:1];
        self.startPlayButton.alpha = 1;
    }else {
        self.startPlayButton.backgroundColor = [UIColor lightGrayColor];
        self.startPlayButton.alpha = 0.4;
    }
}

- (IBAction)resetLevel:(id)sender {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重置关卡" message:@"重置关卡后，将会从第一关重新开始" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self resetLevelRequest];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancleAction];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

-(void)resetLevelRequest {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"正在重置关卡";
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.dimBackground = NO;
    
    AVUser *currentUser = [AVUser currentUser];
    [currentUser setObject:@(1) forKey:@"level"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && error == nil) {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"重置关卡成功";
            [self.hud hide:YES afterDelay:1];
            
            [self performSelector:@selector(reload:) withObject:nil afterDelay:1];
        }else {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"服务器更新数据失败";
            [self.hud hide:YES afterDelay:1];
            [self performSelector:@selector(reload:) withObject:nil afterDelay:1];
        }
    }];
}

@end
