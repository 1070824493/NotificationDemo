//
//  iOS10NotificationViewController.m
//  Notification
//
//  Created by loyo_tangyi on 2017/1/11.
//  Copyright © 2017年 loyo. All rights reserved.
//

#import "iOS10GeneralLocalNotification.h"
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>


@interface iOS10GeneralLocalNotification ()

@end

@implementation iOS10GeneralLocalNotification

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//MARK:发送延时通知
- (IBAction)sendDelayLocalNotificationAction:(id)sender {
    
    //创建Trigger
    UNTimeIntervalNotificationTrigger *timeIntervalTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    //创建Content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"delayLocalNotification_title";
    content.subtitle = @"delayLocalNotification_subtitle";
    content.body = @"delayLocalNotification_body";
    content.badge = @10;
    content.sound = [UNNotificationSound soundNamed:@"alert.wav"];
    content.userInfo = @{@"test":@"delayLocalNotification"};
    
    //创建request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"test10_category_Delay" content:content trigger:timeIntervalTrigger];
    
    //发送
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"通知%@发送成功",request.identifier);
        }
    }];
}

//MARK:修改延时通知
- (IBAction)changeDelayLocalNotificationAction:(id)sender {
    //创建新的Trigger,这次只延时1秒
    UNTimeIntervalNotificationTrigger *timeIntervalTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    //创建Content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //标题不变
    content.title = @"delayLocalNotification_title";
    content.subtitle = @"delayLocalNotification_subtitle";
    //修改body和传输的参数
    content.body = @"延时通知修改";
    content.badge = @10;
    content.sound = [UNNotificationSound soundNamed:@"alert.wav"];
    content.userInfo = @{@"test":@"延时通知修改"};
    
    //创建request,保证ID一致
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"test10_category_Delay" content:content trigger:timeIntervalTrigger];
    
    //发送
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"修改通知%@发送成功",request.identifier);
        }
    }];
    
    
}

//MARK:发送定期通知
- (IBAction)sendDateLocalNotificationAction:(id)sender {
    //创建Trigger
    NSDateComponents *components = [[NSDateComponents alloc]init];
    
//    components.hour = 15;
//    components.minute = 14;
    components.second = 0;
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    //创建Content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"DateLocalNotification_title";
    content.subtitle = @"DateLocalNotification_subtitle";
    content.body = @"DateLocalNotification_body";
    content.badge = @10;
    content.sound = [UNNotificationSound soundNamed:@"alert.wav"];
    content.userInfo = @{@"test":@"DateLocalNotification"};
    
    //创建request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"test10_category_Date" content:content trigger:calendarTrigger];
    
    //发送
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"通知%@发送成功",request.identifier);
        }
    }];

}

//MARK:发送定点通知
- (IBAction)sendLocationLocalNotificationAction:(id)sender {
    //创建Trigger
    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(40.039238, 116.422371) radius:250 identifier:@"媒体村"];
    region.notifyOnExit = YES;
    region.notifyOnEntry = YES;
    UNLocationNotificationTrigger *locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:NO];
    
    //创建Content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"DateLocalNotification_title";
    content.subtitle = @"DateLocalNotification_subtitle";
    content.body = @"DateLocalNotification_body";
    content.badge = @10;
    content.sound = [UNNotificationSound soundNamed:@"alert.wav"];
    content.userInfo = @{@"test":@"DateLocalNotification"};
    
    //创建request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"test10_category_Location" content:content trigger:locationTrigger];
    
    //发送
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"通知%@发送成功",request.identifier);
        }
    }];

}


//MARK:取消所有通知
- (IBAction)cancelAllLocalNotificationAction:(id)sender {
//    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
}
@end
