//
//  ViewController.m
//  MOB-第三方登录与分享
//
//  Created by wp on 16/4/8.
//  Copyright © 2016年 wp. All rights reserved.
//

#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>

#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //登录按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *dlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dlButton.frame = CGRectMake(130, 250, 60, 60);
    dlButton.layer.cornerRadius = dlButton.frame.size.width/2.0;
    dlButton.layer.masksToBounds = YES;
    [dlButton setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    
    [dlButton addTarget:self
                 action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view  addSubview:dlButton];

    
}
//登录方法
-(void)login:(UIButton *)sender{

    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     { if (state == SSDKResponseStateSuccess)
     {
         NSString *useid = user.uid;
         NSRange rang={0,5};
         NSString *userId0 = [useid substringWithRange:rang];
         NSString *userId = [NSString stringWithFormat:@"user%@",userId0];
         NSLog(@"userID%@",userId);
         NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
         [defaults setObject:user.nickname forKey:@"user"];
         [defaults setObject:userId forKey:@"userId"];
         [defaults setBool:YES forKey:@"isLogin"];
         
     }
         
     else
     {
         NSLog(@"%@",error);
     }
         
     }];

    
}
//分享方法
-(void)share{

    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"qq"]];
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.title
                                         images:imageArray
                                            url:nil
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
