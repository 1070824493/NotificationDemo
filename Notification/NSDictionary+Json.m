//
//  NSDictionary+Json.m
//  Notification
//
//  Created by ty on 2017/1/6.
//  Copyright © 2017年 loyo. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)

- (NSString *)JsonString{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (!parseError) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}
@end
