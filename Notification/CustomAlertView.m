//
//  CustomAlertView.m
//  Notification
//
//  Created by loyo_tangyi on 2017/1/10.
//  Copyright © 2017年 loyo. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
