//
//  WebView.h
//  SuyChenPuzzleDemo
//
//  Created by li on 12/12/23.
//  Copyright © 2023 suychen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface WebViewVC : UIViewController <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end
