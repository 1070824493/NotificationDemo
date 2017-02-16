//
//  OnceLocalNotificationViewController.m
//  Notification
//
//  Created by loyo_tangyi on 2017/1/6.
//  Copyright © 2017年 loyo. All rights reserved.
//

#import "iOS8_9GeneralLocalNotification.h"


@interface iOS8_9GeneralLocalNotification ()


@end

@implementation iOS8_9GeneralLocalNotification

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

//程序终止状态，延迟5秒发送
- (IBAction)sendOnceNotificationTerminated:(id)sender {
    [self sendOnceLocalNotificationWithUserInfo:@{@"test":@"sendOnceNotificationTerminated"}];
}


//后台通知，延迟5秒，需要5秒内切换到后台
- (IBAction)sendOnceNotificationBackground:(id)sender {
    [self sendOnceLocalNotificationWithUserInfo:@{@"test":@"sendOnceNotificationBackground"}];
}

//前台通知，延迟5秒，点击后等待5秒
- (IBAction)sendOnceNotificationForeground:(id)sender {
    [self sendOnceLocalNotificationWithUserInfo:@{@"test":@"sendOnceNotificationForeground"}];
}

//发送定时通知，延迟5秒，一分钟一次
- (IBAction)sendRepeatNotification:(id)sender {
    [self sendRepeatLocalNotificationWithUserInfo:@{@"test" : @"sendRepeatNotification"}];
}

//取消所有定时通知
- (IBAction)cancelAllLocalNotification:(id)sender {
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}





/**
 单次本地通知发送
 
 @param userinfo 可以是后台提供或者说本地需要用的任意信息都行，可空
 */
- (void)sendOnceLocalNotificationWithUserInfo:(NSDictionary *)userinfo{
    //测试发送本地通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //触发通知时间
    localNotification.fireDate = [NSDate dateWithTimeInterval:kDefaultDelayTime sinceDate:[NSDate date]];
    
    //没有设置defaultTimeZone的话就是系统默认的时区
    localNotification.timeZone = [NSTimeZone  defaultTimeZone];
    
    //应用收到通知时右上角显示的数字
    localNotification.applicationIconBadgeNumber = 1;
    
    //通知需要传递的参数
    localNotification.userInfo = userinfo;
    
    //设置锁屏时屏幕显示的文字（滑动来“自己设置的文字”）
    localNotification.alertAction = @"alertAction";
    
    //下拉通知栏显示的消息标题。
    //由于现有设备的版本不够，仅实测iOS9锁屏界面不显示alertTitle，iOS10版本在锁屏界面会显示alertTitle。
    localNotification.alertTitle = @"alertTitle";
    
    //标题下方展示的内容，为了方便就取userinfo里面的value吧。
    localNotification.alertBody = [userinfo objectForKey:@"test"];
    
    //通知时的音效
    localNotification.soundName = @"alert.wav";

    //发起通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

/**
 发送一个循环提示的本地通知,方便测试,5秒后发送,每隔一分钟提示,
 
 @param userinfo 传递的信息
 */
- (void)sendRepeatLocalNotificationWithUserInfo:(NSDictionary *)userinfo{
    //测试发送本地通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //触发通知时间,当然也可以用NSDateComponents进行设置,
    localNotification.fireDate = [NSDate dateWithTimeInterval:kDefaultDelayTime sinceDate:[NSDate date]];
    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.repeatInterval = kCFCalendarUnitMinute;
    
//    localNotification.repeatCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    
    //通知内容
    localNotification.alertBody = @"RepeatLocalNotification_alertBody";
    localNotification.alertAction = @"RepeatLocalNotification_alertAction";
    
    localNotification.alertTitle = @"RepeatLocalNotification_alertTitle";
    
    localNotification.applicationIconBadgeNumber = 1;
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //通知参数
    localNotification.userInfo = userinfo;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}




@end
