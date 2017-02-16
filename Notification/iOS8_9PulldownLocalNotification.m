//
//  iOS8-9SpecialLocalNotification.m
//  Notification
//
//  Created by loyo_tangyi on 2017/1/12.
//  Copyright © 2017年 loyo. All rights reserved.
//

#import "iOS8_9PulldownLocalNotification.h"
#import <CoreLocation/CoreLocation.h>

@interface iOS8_9PulldownLocalNotification ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *manager;
@end

@implementation iOS8_9PulldownLocalNotification

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//发送可下拉本地通知
- (IBAction)sendPulldownLocalNotificationAction:(id)sender {
    [self sendPulldownLocalNotificationWithUserInfo:@{@"test" : @"PulldownLocalNotification"}];
}



/**
 发送可下拉本地通知

 @param userinfo 传输的参数(可空)
 */
- (void)sendPulldownLocalNotificationWithUserInfo:(NSDictionary *)userinfo{
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
    
    //下拉通知栏显示的消息标题。
    //8.2可用,由于现有设备的版本不够，仅实测iOS9锁屏界面不显示alertTitle，iOS10版本在锁屏界面会显示alertTitle。
    localNotification.alertTitle = @"alertTitle";
    
    //标题下方展示的内容，为了方便就取userinfo里面的value吧。
    localNotification.alertBody = [userinfo objectForKey:@"test"];
    
    //通知时的音效
    localNotification.soundName = @"alert.wav";
    
    //设置下拉category
    localNotification.category = @"test_category";
    //发起通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}



//发送带定位的通知
- (IBAction)sendLocationLocalNotification:(id)sender {
    
    _manager = [[CLLocationManager alloc]init];
    _manager.delegate = self;
//    [_manager requestWhenInUseAuthorization];
    [_manager requestAlwaysAuthorization];
    
}

/**
 发送带定位的本地通知
 
 @param userinfo 传送的信息
 */
- (void)sendLocationLocalNotificationWithUserInfo:(NSDictionary *)userinfo{
    UILocalNotification *locationNotification = [[UILocalNotification alloc]init];
    
    locationNotification.alertBody = [userinfo objectForKey:@"test"];
    
    //    regionTriggersOnce为YES时，通知只会执行一次，为NO时，每次进入或者离开都会通知，具体根据region属性来配置
    locationNotification.regionTriggersOnce = YES;
    
    //当前位置半径50米以内(北京的某个小村庄),
    locationNotification.region = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(40.039238, 116.422371) radius:50 identifier:@"媒体村"];
    //默认为YES,仅列举属性
    locationNotification.region.notifyOnExit = YES;
    locationNotification.region.notifyOnEntry = YES;
    [[UIApplication sharedApplication]scheduleLocalNotification:locationNotification];
}

//MARK:CLLocationManagerDelegate
//授权状态改变,从未授权时默认为kCLAuthorizationStatusNotDetermined
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self sendLocationLocalNotificationWithUserInfo:@{@"test":@"LocationLocalNotification"}];
    }
}

//已经离开某区域
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
    
    [CustomAlertView showAlertViewWithTitle:@"定位通知" message:@"你已离开某区域"];
}

//已经进入某区域
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    [CustomAlertView showAlertViewWithTitle:@"定位通知" message:@"你已进入某区域"];
}
@end
