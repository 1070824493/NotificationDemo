//
//  AppDelegate.m
//  Notification
//
//  Created by loyo_tangyi on 2016/12/27.
//  Copyright © 2016年 loyo. All rights reserved.
//

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>




@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //测试pull requests
    
    //测试pull requests
    if (launchOptions) {
        UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        //归档的作用是为了应用terminal状态启动方便提示而已
        if (localNotification) {
            NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/LocalNotification"];
            [NSKeyedArchiver archiveRootObject:localNotification.userInfo toFile:filePath];
        }
        if (remoteNotification) {
            NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/RemoteNotification"];
            [NSKeyedArchiver archiveRootObject:remoteNotification toFile:filePath];
        }
        
    }
    
    //注册通知
    [self registerNotification];
    return YES;
}

- (void)registerNotification{
    //只兼容8-10,为了提高体验，运行时不直接获取权限，故注释。
    if (IS_IOS_10) {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted) {
//                [[UIApplication sharedApplication] registerForRemoteNotifications];
//            }
//        }];

        //设置代理
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
//    else if (IS_IOS_8){
//        //ios8注册通知
//        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
//        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }else{
//        //ios7及之前注册通知
//        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:type];
//
//    }
}

//- (void)

/**
 注册通知成功的回调方法
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //向APNS注册成功，收到返回的deviceToken
    NSString *realDeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
    //去除<>和空格
    realDeviceToken = [realDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    realDeviceToken = [realDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    realDeviceToken = [realDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //保存到本地
    [[NSUserDefaults standardUserDefaults]setObject:realDeviceToken forKey:@"deviceToken"];
    
    //发送已经收到token的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AppDidReceivedRemoteNotificationDeviceToken" object:nil userInfo:@{@"deviceToken" : realDeviceToken}];
    NSLog(@"deviceToken:%@",realDeviceToken);
}


/**
 注册通知失败的回调方法
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
}



/**
 已经收到远程推送消息
 @param userInfo 收到的userInfo信息
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userInfo:%@",userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"程序运行中收到通知");
    }else{
        NSLog(@"程序不活跃中收到通知");
    }
}


/**
 后台模式收到的远程推送信息，需要开启后台模式的远程推送，实现了此方法，上面的方法就失效。
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"userInfo:%@",userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"程序运行中收到通知");
    }else{
        NSLog(@"程序不活跃中收到通知");
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}


/**
 已经收到本地推送消息

 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"didReceiveLocalNotification:%@",notification.userInfo);
    if (notification.region != nil) {
        [CustomAlertView showAlertViewWithTitle:@"检测到定位本地通知" message:[notification.userInfo JsonString]];
    }else{
        [CustomAlertView showAlertViewWithTitle:@"检测到本地通知" message:[notification.userInfo JsonString]];
    }
    
}

//本地通知category属性使用,iOS8引入
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    
    completionHandler();
}
//本地通知category属性使用.iOS9引入
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler{

    NSLog(@"用户输入的信息为:%@",[responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey]);
    completionHandler();
}


//远程通知category属性使用.iOS8引入
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    
    completionHandler();
}
//远程通知category属性使用,iOS9引入
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler{
    
    NSLog(@"用户输入的信息为:%@",[responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey]);
    completionHandler();
}






//MARK: iOS10通知代理方法,程序在前台时收到通知调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    UNNotificationRequest *request = notification.request;
    NSDictionary *userInfo = request.content.userInfo;
    
    if ([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"收到了一个远程推送:%@",userInfo);
    }
    else{
        NSLog(@"收到了一个本地推送:%@",userInfo);
    }
    
    //此方法回调,设置程序前台是,banner提示框的显示选项,
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

//MARK: iOS10通知代理方法，通知前后台点击时会触发。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"userInfo:%@",userInfo);
    
    completionHandler();
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
