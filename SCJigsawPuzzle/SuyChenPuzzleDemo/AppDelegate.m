//
//  AppDelegate.m
//  SuyChenPuzzleDemo
//
//  Created by CSY on 2019/2/15.
//  Copyright © 2019 suychen. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UIKit/UIKit.h>
#import "admob/AppOpenAdManager.h"
#import "admob/GoogleMobileAdsConsentManager.h"
#import "Utils.h"

@interface AppDelegate () <AppOpenAdManagerDelegate, GADFullScreenContentDelegate>
@property(strong, nonatomic) GADAppOpenAd* appOpenAd;
@property (nonatomic ,assign) BOOL isRemove;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    HomeViewController *mMainViewController = [HomeViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mMainViewController];
    [self.window setRootViewController:nav];
//    [self startGoogleMobileAdsSDK];

    return YES;
}

- (void)startAD:(UIViewController *)nav
{
  AppOpenAdManager.sharedInstance.delegate = self;

  __weak __typeof__(self) weakSelf = self;
  [GoogleMobileAdsConsentManager.sharedInstance
      gatherConsentFromConsentPresentationViewController:self
                                consentGatheringComplete:^(NSError *_Nullable consentError) {
                                  __strong __typeof__(self) strongSelf = weakSelf;
                                  if (!strongSelf) {
                                    return;
                                  }

                                  if (consentError) {
                                    // Consent gathering failed.
                                    NSLog(@"Error: %@", consentError.localizedDescription);
                                  }

                                  if (GoogleMobileAdsConsentManager.sharedInstance.canRequestAds) {
                                    [strongSelf startGoogleMobileAdsSDK];
                                  }
                                  
                                }];

  // This sample attempts to load ads using consent obtained in the previous session.
  if (GoogleMobileAdsConsentManager.sharedInstance.canRequestAds) {
    [self startGoogleMobileAdsSDK];
  }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AppOpenAdManager.sharedInstance showAdIfAvailable:nav];
    });

}

- (void)startGoogleMobileAdsSDK {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    // Initialize the Google Mobile Ads SDK.
    [GADMobileAds.sharedInstance startWithCompletionHandler:nil];

    // Request an ad.
    [AppOpenAdManager.sharedInstance loadAd];
  });
}

- (void)adDidComplete {
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
//    self.appOpenAd = nil;
//    [self requestAppOpenAd];

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
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isKeyWindow == YES"];
//    UIWindow *keyWindow = [[application.windows filteredArrayUsingPredicate:predicate] firstObject];
//    UIViewController *rootViewController = keyWindow.rootViewController;
//    // Do not show app open ad if the current view controller is SplashViewController.
//    if (!rootViewController) {
//      return;
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [AppOpenAdManager.sharedInstance showAdIfAvailable:rootViewController];
//    });
    
    self.isRemove = [[NSUserDefaults standardUserDefaults] objectForKey:@"remove_ads"];
    if (!self.isRemove) {
        [self tryToPresentAd];
        [Utils getAdvertisingIdentifier];
    }

}

- (void)tryToPresentAd {
    
  if (self.appOpenAd) {
    UIViewController *rootController = self.window.rootViewController;
    [self.appOpenAd presentFromRootViewController:rootController];

  } else {
    // If you don't have an ad ready, request one.
    [self requestAppOpenAd];
  }
}

- (void)requestAppOpenAd {
  self.appOpenAd = nil;
  [GADAppOpenAd loadWithAdUnitID:@"ca-app-pub-7962668156781439/8443792766"
                         request:[GADRequest request]
                     orientation:UIInterfaceOrientationPortrait
               completionHandler:^(GADAppOpenAd *_Nullable appOpenAd, NSError *_Nullable error) {
                 if (error) {
                   NSLog(@"Failed to load app open ad: %@", error);
                   return;
                 }
                 self.appOpenAd = appOpenAd;
                self.appOpenAd.fullScreenContentDelegate = self;
               }];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
  NSLog(@"didFailToPresentFullScreenContentWithError");
  [self requestAppOpenAd];

}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"adWillPresentFullScreenContent");
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"adDidDismissFullScreenContent");
  [self requestAppOpenAd];
}

@end
