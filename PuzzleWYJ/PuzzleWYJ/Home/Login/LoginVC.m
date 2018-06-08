//
//  LoginVC.m
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/9/30.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) NSDictionary *loginResponseDict;
@property (nonatomic, strong) NSDictionary *userLevelInfoResponseDict;

@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RootViewBackColor;
    _loginButton.backgroundColor = [UIColor whiteColor];
    _loginButton.layer.cornerRadius = 15;
    _signUpButton.backgroundColor = [UIColor whiteColor];
    _signUpButton.layer.cornerRadius = 15;
    
    NSString *name = [UserDefault getUserName];
    if (name) {
        
        NSString *password = [UserDefault getPassword];
        self.nameTextField.text = name;
        self.passwordTextField.text = password;
    }
}

- (IBAction)loginAction:(UIButton *)sender {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"正在登录中";
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.dimBackground = NO;
    
    NSString *name = self.nameTextField.text;
    NSString *pw = self.passwordTextField.text;
    
    [AVUser logInWithUsernameInBackground:name password:pw block:^(AVUser *user, NSError *error) {
        
        if (error != nil || user == nil) {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"登录失败";
            [self.hud hide:YES afterDelay:0.8];
            
            return ;
        }
        
        [self.hud hide:YES];
        
        [UserDefault setUserName:name];
        [UserDefault setPassword:pw];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotificationKey object:nil];
        
    }];
}

-(IBAction)signUp:(UIButton *)sender {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"正在注册中";
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.dimBackground = NO;
    
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = self.nameTextField.text;
    user.password = self.passwordTextField.text;

    [user setObject:@(1) forKey:@"level"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.hud hide:YES];
            // 注册成功
            [self loginAction:nil];
        } else {
            NSString *errorMsg = @"注册失败";
            
            if (error.code == 202) {
                errorMsg = @"用户名已经存在";
            }
            if (error.code == 28) {
                errorMsg = @"请求超时";
            }
            if (error.code == 7) {
                errorMsg = @"连接服务器失败";
            }
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = errorMsg;
            [self.hud hide:YES afterDelay:0.8];
        }
    }];
}

@end
