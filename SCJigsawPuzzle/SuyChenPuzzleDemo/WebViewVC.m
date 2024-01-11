#import "WebViewVC.h"

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化 WKWebView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;

    // 获取 HTML 文件的本地路径
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"child-privacy" ofType:@"html"];
    NSURL *htmlURL = [NSURL fileURLWithPath:htmlPath];

    // 加载 HTML 文件
    [self.webView loadFileURL:htmlURL allowingReadAccessToURL:htmlURL];

    // 将 WKWebView 添加到视图中
    [self.view addSubview:self.webView];
}

@end

