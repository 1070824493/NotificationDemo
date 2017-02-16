//
//  NotificationViewController.m
//  UNNotificationContentExtension
//
//  Created by loyo_tangyi on 2017/2/15.
//  Copyright © 2017年 loyo. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = [notification.request.content.body stringByAppendingString:@"+ContentExtension增加字段"];
}

@end
