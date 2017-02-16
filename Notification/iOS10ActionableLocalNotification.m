//
//  iOS10ActionableLocalNotification.m
//  Notification
//
//  Created by loyo_tangyi on 2017/1/13.
//  Copyright © 2017年 loyo. All rights reserved.
//

#import "iOS10ActionableLocalNotification.h"
#import <UserNotifications/UserNotifications.h>
@interface iOS10ActionableLocalNotification ()

@end

@implementation iOS10ActionableLocalNotification

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//发送可操作的通知
- (IBAction)sendActionableLocalNotificationAction:(id)sender {
    //先在通知中心设置category
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:[NSSet setWithObject:[self setActionableCategory]]];
    
    //发送通知
    [self sendCategoryLocalNotification];
}


- (IBAction)sendPictureLocalNotification:(id)sender {
    [self sendPictureLocalNotification];
}

//配置category
- (UNNotificationCategory * )setActionableCategory{
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1_identifier" title:@"点击会激活应用" options:UNNotificationActionOptionForeground];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2_identifier" title:@"解锁后执行" options:UNNotificationActionOptionAuthenticationRequired];
    
    //输入文本型Action,类型为红色字体
    UNTextInputNotificationAction *action3 = [UNTextInputNotificationAction actionWithIdentifier:@"action3_identifier" title:@"文本输入" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"自定义按钮" textInputPlaceholder:@"请输入任意文字"];
    
    //创建category
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test10_category" actions:@[action1,action2,action3] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];

    return category;
}

//发送通知
- (void)sendCategoryLocalNotification{
    //创建Trigger
    UNTimeIntervalNotificationTrigger *timeIntervalTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    //创建Content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"CategoryLocalNotification_title";
    content.subtitle = @"CategoryLocalNotification_subtitle";
    content.body = @"CategoryLocalNotification_body";
    content.badge = @1;
    content.userInfo = @{@"test":@"CategoryLocalNotification"};
    
    //设置category
    content.categoryIdentifier = @"test10_category";
    
    //创建request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"test10_category_Delay" content:content trigger:timeIntervalTrigger];
    
    //发送
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"通知%@发送成功",request.identifier);
        }
    }];

}

//发送带图片的通知
- (void)sendPictureLocalNotification{
    //创建Trigger
    UNTimeIntervalNotificationTrigger *timeIntervalTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    //创建Content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"PictureLocalNotification_title";
    content.subtitle = @"PictureLocalNotification_subtitle";
    content.body = @"PictureLocalNotification_body";
    content.badge = @1;
    content.userInfo = @{@"test":@"PictureLocalNotification"};

    //设置Content图片
//    本地图片
//    NSURL *imageUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"IMG_1994" ofType:@"JPG"]];
//    网络图片,简化测试,就没啥开线程下载图片的过程了,仅本地通知测试使用，是肯定会卡的。
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i.niupic.com/images/2017/01/16/JIKcuq.jpg"]];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/img.jpg"];
    [data writeToFile:filePath atomically:YES];
    NSURL *imageUrl = [NSURL fileURLWithPath:filePath];
    
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachmentIdentifier" URL:imageUrl options:nil error:nil];
    content.attachments = @[attachment];

    //创建request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"test10_Picture_Identifier" content:content trigger:timeIntervalTrigger];
    
    //发送
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"通知%@发送成功",request.identifier);
        }
    }];
    
}

@end
