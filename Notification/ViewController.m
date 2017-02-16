//
//  ViewController.m
//  Notification
//
//  Created by loyo_tangyi on 2017/1/6.
//  Copyright © 2017年 loyo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/LocalNotification"];
    
    NSDictionary *userinfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        [CustomAlertView showAlertViewWithTitle:@"检测到程序杀死后的本地通知" message:[userinfo JsonString]];
        //显示一次删除文件
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    NSString *filePath2 = [NSHomeDirectory() stringByAppendingString:@"/Documents/RemoteNotification"];
    
    NSDictionary *userinfo2 = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath2];
    
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath2]) {
        [CustomAlertView showAlertViewWithTitle:@"检测到程序杀死后的本地通知" message:[userinfo2 JsonString]];
        //显示一次删除文件
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
