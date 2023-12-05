//
//  Utils.m
//  SuyChenPuzzleDemo
//
//  Created by li on 11/27/23.
//  Copyright © 2023 suychen. All rights reserved.
//

#import "Utils.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation Utils
+ (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }

    else if([deviceType isEqualToString:@"iPod touch"]) {

        //iPod Touch

        return NO;

    }

    else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;

}


+ (void)getAdvertisingIdentifier {
    if (@available(iOS 14, *)) {
            // iOS14及以上版本需要先请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // 获取到权限后，依然使用老方法获取idfa
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSLog(@"%@",idfa);
                } else {
                         NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");

                }
            }];
        } else {
            // iOS14以下版本依然使用老方法
            // 判断在设置-隐私里用户是否打开了广告跟踪
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfa);

            } else {
                NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
            }
        }
}


@end
