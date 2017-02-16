//
//  AuthorizationViewController.m
//  Notification
//
//  Created by loyo_tangyi on 2016/12/28.
//  Copyright © 2016年 loyo. All rights reserved.
//

#import "AuthorizationViewController.h"

#import <UserNotifications/UserNotifications.h>



/**
 通知手动获取权限界面
 */
@interface AuthorizationViewController ()<UNUserNotificationCenterDelegate>
@property (weak, nonatomic) IBOutlet UILabel *AuthTokenLabel;

@end

@implementation AuthorizationViewController


- (void)dealloc
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (IBAction)requestAuthAction:(UIBarButtonItem *)sender {
    
    
    
    
    //请求通知权限
    if (IS_IOS_10) {
        //iOS10通知注册方法
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
           
        }];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //注册远程通知
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }else{
                if (error) {
                    NSLog(@"requestAuthorizationError:%@",error);
                }
                else{
                    //用户拒绝授权
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.AuthTokenLabel.text = @"已拒绝授权，请卸载后重新授权或者进入设置手动授权";
                    });
                }
            }
        }];
        
    }
    else{
        //ios8-ios9通知注册方法
        
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc]init];
        category.identifier = @"test_category";
        
        //此按钮点击会唤醒程序到前台
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc]init];
        action1.identifier = @"test_action1";
        action1.activationMode = UIUserNotificationActivationModeForeground;
        action1.title = @"前台模式按钮1";
        
        //此按钮点击只会在后台处理数据,不会唤醒程序,iOS9下为输入按钮
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc]init];
        action2.identifier = @"test_action2";
        action2.activationMode = UIUserNotificationActivationModeBackground;
        action2.title = @"后台模式按钮2";
        
        //这两个属性是iOS9.0的属性,可以输入文字,如果是iOS9,action2即为输入模式按钮
        if (IS_IOS_9) {
            action2.behavior = UIUserNotificationActionBehaviorTextInput;
            action2.parameters = @{UIUserNotificationTextInputActionButtonTitleKey : @"自定义输入"};
        }
        
        [category setActions:@[action1,action2] forContext:UIUserNotificationActionContextDefault];
        
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){

            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:[NSSet setWithObject:category]]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

       
    //监听是否收到token通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveDeviceToken:) name:@"AppDidReceivedRemoteNotificationDeviceToken" object:nil];
    
    if (IS_IOS_10) {
        //检查是否授权
        [[UNUserNotificationCenter currentNotificationCenter]getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                    //已授权
                    self.AuthTokenLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
                }
                else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
                    //已拒绝授权
                    self.AuthTokenLabel.text = @"已拒绝授权，请卸载后重新授权或者进入设置手动授权";
                }
            });
        }];

    }
    else{
        if ([self isAllowedNotificationLessThanIOS10]) {
            //已授权
            self.AuthTokenLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
        }else{
            //已拒绝授权
            self.AuthTokenLabel.text = @"已拒绝授权或仍未授权，请尝试重新授权。";
        }
    }
    
}

//ios10以下监测是否开启通知授权
- (BOOL)isAllowedNotificationLessThanIOS10{
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication]currentUserNotificationSettings];
    if (settings.types != UIUserNotificationTypeNone) {
        return YES;
    }
    return NO;
}

- (void)didReceiveDeviceToken:(NSNotification *)notification{
    NSString *token = notification.userInfo[@"deviceToken"];
    self.AuthTokenLabel.text = token;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
