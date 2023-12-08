//
//  ViewController.m
//  CollectionCircleDemo
//
//  Created by Damon on 2017/5/24.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "SuccessView.h"
#import <UIColor+Expanded.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "Utils.h"
@interface SuccessView ()
@property (nonatomic ,strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GADBannerView *bannerView1;
@property (nonatomic,strong) GADBannerView *bannerView2;
@property (nonatomic,strong) GADBannerView *bannerView3;
@property (nonatomic ,assign) BOOL isRemove;

@end

@implementation SuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isRemove = [[NSUserDefaults standardUserDefaults] objectForKey:@"remove_ads"];

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

- (GADBannerView *)bannerView1
{
    if (_bannerView1==nil) {
        _bannerView1 = [[GADBannerView alloc]initWithFrame:CGRectMake(0,self.backView.frame.origin.y - 60 , self.bounds.size.width, 60)];
        _bannerView1.adUnitID = @"ca-app-pub-7962668156781439/7518504152";
        _bannerView1.rootViewController = self.rootVc;


    }
    return _bannerView1;
}

- (GADBannerView *)bannerView2
{
    if (_bannerView2==nil) {
        _bannerView2 = [[GADBannerView alloc]initWithFrame:CGRectMake(0, self.backView.frame.origin.y + self.backView.bounds.size.height, UIScreen.mainScreen.bounds.size.width, 60)];
        _bannerView2.adUnitID = @"ca-app-pub-7962668156781439/4126069968";
        _bannerView2.rootViewController = self.rootVc;

    }
    return _bannerView2;
}

- (GADBannerView *)bannerView3
{
    if (_bannerView3==nil) {
        _bannerView3 = [[GADBannerView alloc]initWithFrame:CGRectMake(0, self.bannerView2.frame.origin.y, UIScreen.mainScreen.bounds.size.width, 60)];
        _bannerView3.adUnitID = @"ca-app-pub-7962668156781439/1355640230";
        _bannerView3.rootViewController = self.rootVc;

    }
    return _bannerView3;
}


- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width - 60 , self.bounds.size.width+80)];
        _backView.backgroundColor = UIColor.whiteColor;
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
        [_homeButton setTitle:NSLocalizedString(@"返回首页", nil) forState:UIControlStateNormal];
        [_homeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _homeButton.center = CGPointMake(self.backView.bounds.size.width/2, _homeButton.center.y);
        _homeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return  _homeButton;
}

- (UIButton *)gradButton
{
    if (_gradButton == nil) {
        _gradButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _homeButton.frame.origin.y + 90, self.backView.bounds.size.width - 40, 60)];
        _gradButton.backgroundColor = [UIColor colorWithHexString:@"#EC661B"];
        _gradButton.layer.cornerRadius = 30;
        _gradButton.layer.masksToBounds = YES;
        [_gradButton setTitle:NSLocalizedString(@"增加难度", nil) forState:UIControlStateNormal];
        [_gradButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _gradButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _gradButton.center = CGPointMake(self.backView.bounds.size.width/2, _gradButton.center.y);
    }
    return  _gradButton;
}



- (UIButton *)nextButton
{
    if (_nextButton == nil) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _gradButton.frame.origin.y + 90, self.backView.bounds.size.width - 40, 60)];
        _nextButton.backgroundColor = [UIColor colorWithHexString:@"#4DB90D"];
        _nextButton.layer.cornerRadius = 30;
        _nextButton.layer.masksToBounds = YES;
        [_nextButton setTitle:NSLocalizedString(@"下一张", nil) forState:UIControlStateNormal];
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
                         self.alpha = 1.0;
                         self.backView.alpha = 1.0;
                         self.backView.transform = CGAffineTransformIdentity; // 恢复正常大小
                     }
                     completion:^(BOOL finished) {
        if (!self.isRemove) {
            [self addSubview:self.bannerView1];
            [self addSubview:self.bannerView2];
            [self addSubview:self.bannerView3];

        }
        self.bannerView1.frame = CGRectMake(0,self.backView.frame.origin.y - 60 , self.bounds.size.width, 60);
        self.bannerView2.frame = CGRectMake(0, self.backView.frame.origin.y + self.backView.bounds.size.height, self.bounds.size.width, 60);
        self.bannerView3.frame = CGRectMake(0, self.bannerView2.frame.origin.y + 60, UIScreen.mainScreen.bounds.size.width, 60);

        [self.bannerView1 loadRequest:[GADRequest request]];
        [self.bannerView2 loadRequest:[GADRequest request]];
        [self.bannerView3 loadRequest:[GADRequest request]];



    }];
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
