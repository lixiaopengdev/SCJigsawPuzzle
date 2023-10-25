//
//  ViewController.m
//  CollectionCircleDemo
//
//  Created by Damon on 2017/5/24.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "SuccessView.h"
#import <UIColor+Expanded.h>

@interface SuccessView ()
@property (nonatomic ,strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *gradButton;
@property (strong,nonatomic) UIButton *homeButton;
@property (strong,nonatomic) UIButton *nextButton;
@end

@implementation SuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    [self.backView addSubview:self.imageView];
    [self.backView addSubview:self.homeButton];
    [self.backView addSubview:self.gradButton];
    [self.backView addSubview:self.nextButton];
}


- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width - 60 , self.bounds.size.width+80)];
        _backView.backgroundColor = UIColor.redColor;
        _backView.center = self.center;
        _backView.layer.cornerRadius = 20;
        _backView.layer.masksToBounds = YES;
    }
    return  _backView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backView.bounds.size.width, self.backView.bounds.size.width/1.96)];
        _imageView.image = [UIImage imageNamed:@"Congratulations"];
    }
    return _imageView;
}

- (UIButton *)homeButton
{
    if (_homeButton == nil) {
        _homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _imageView.frame.origin.y + _imageView.bounds.size.height + 30, self.backView.bounds.size.width - 40, 60)];
        _homeButton.backgroundColor = [UIColor colorWithHexString:@"#FFBB00"];
        _homeButton.layer.cornerRadius = 30;
        _homeButton.layer.masksToBounds = YES;
        [_homeButton setTitle:@"返回首页" forState:UIControlStateNormal];
        [_homeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _homeButton.center = CGPointMake(self.backView.bounds.size.width/2, _homeButton.center.y);
        _homeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return  _homeButton;
}

- (UIButton *)gradButton
{
    if (_gradButton == nil) {
        _gradButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _homeButton.frame.origin.y + 90, self.backView.bounds.size.width - 20, 60)];
        _gradButton.backgroundColor = [UIColor colorWithHexString:@"#EC661B"];
        _gradButton.layer.cornerRadius = 30;
        _gradButton.layer.masksToBounds = YES;
        [_gradButton setTitle:@"增加难度" forState:UIControlStateNormal];
        [_gradButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _gradButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _gradButton.center = CGPointMake(self.backView.bounds.size.width/2, _gradButton.center.y);
    }
    return  _gradButton;
}

- (UIButton *)nextButton
{
    if (_nextButton == nil) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _gradButton.frame.origin.y + 90, self.backView.bounds.size.width - 20, 60)];
        _nextButton.backgroundColor = [UIColor colorWithHexString:@"#4DB90D"];
        _nextButton.layer.cornerRadius = 30;
        _nextButton.layer.masksToBounds = YES;
        [_nextButton setTitle:@"下一张" forState:UIControlStateNormal];
        [_nextButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _nextButton.center = CGPointMake(self.backView.bounds.size.width/2, _nextButton.center.y);
    }
    return  _nextButton;
}


- (void)showWithView:(UIView *)view {
    // 添加自定义视图到内容视图
    [view addSubview:self];
    self.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    self.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    self.backView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.backView.transform = CGAffineTransformMakeScale(0.3, 0.3); // 初始缩小
    [self addSubview:self.backView];
    // 初始透明度设置为0，执行弹簧动画
    self.backView.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7 // 弹性效果
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backView.alpha = 1.0;
                         self.backView.transform = CGAffineTransformIdentity; // 恢复正常大小
                     }
                     completion:nil];
}

- (void)dismiss {
    // 执行淡出动画
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.backView.transform = CGAffineTransformMakeScale(0.1, 0.1); // 缩小并消失
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
