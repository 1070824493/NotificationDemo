//
//  CustomAlertView.h
//  Notification
//
//  Created by loyo_tangyi on 2017/1/10.
//  Copyright © 2017年 loyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIAlertView


/**
 纯粹的提示一下
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;

@end
