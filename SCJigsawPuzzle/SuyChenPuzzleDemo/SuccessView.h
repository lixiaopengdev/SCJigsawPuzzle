//
//  ViewController.h
//  CollectionCircleDemo
//
//  Created by Damon on 2017/5/24.
//  Copyright © 2017年 damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessView : UIView

// 弹出自定义视图的方法
- (void)showWithView:(UIView *)view;

// 关闭弹出视图的方法
- (void)dismiss;

@end

