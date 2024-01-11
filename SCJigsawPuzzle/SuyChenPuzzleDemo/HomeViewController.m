//
//  HomeViewController.m
//  SuyChenPuzzleDemo
//
//  Created by CSY on 2019/2/20.
//  Copyright © 2019 suychen. All rights reserved.
//

#import "HomeViewController.h"
#import "PuzzleViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Masonry/Masonry.h>
#import "CYLineLayout.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "Utils.h"
#import "IAPManager.h"
#import <StoreKit/StoreKit.h>
#import "PurchaseView.h"
#import "WebViewVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
#define kJLXWidthScale              0.8       //以6/6s为准宽度缩小系数
#define kJLXHeightScale             0.8//高度缩小系数
#define kJLXBackgroundColor         [UIColor colorWithRed:253.0/255.0 green:242.0/255.0 blue:236.0/255.0 alpha:1.0]     //背景颜色-米黄
#define JLXScreenSize               [UIScreen mainScreen].bounds.size                       //屏幕大小
#define JLXScreenOrigin             [UIScreen mainScreen].bounds.origin                     //屏幕起点

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate,UIImagePickerControllerDelegate, GADFullScreenContentDelegate>
@property (strong, nonatomic) UILabel *rowNum_lb;
@property (strong, nonatomic) UILabel *columnNum_lb;
@property (strong, nonatomic) UISlider *rowSlider;
@property (strong, nonatomic) UISlider *columnSlider;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (assign,nonatomic) NSInteger m_currentIndex;
@property (assign,nonatomic) CGFloat m_dragStartX;
@property (assign,nonatomic) CGFloat m_dragEndX;
@property (nonatomic, strong) GADBannerView *bannerView1;
@property (nonatomic,strong) GADBannerView *bannerView2;
@property(nonatomic, strong) GADInterstitialAd *interstitial;
@property (nonatomic ,strong) PurchaseView *purchaseView;
@property (nonatomic ,assign) BOOL isRemove;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.isRemove = [[NSUserDefaults standardUserDefaults] objectForKey:@"remove_ads"];

    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 29.12)];
    imageview.image = [UIImage imageNamed:@"imgpuzzle" ];
    self.navigationItem.titleView = imageview;
    self.view.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:242.0/255.0 blue:236.0/255.0 alpha:1.0];    //背景颜色-米黄

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"去除广告", nil) style:UIBarButtonItemStyleDone target:self action:@selector(setAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"隐私政策", nil) style:UIBarButtonItemStyleDone target:self action:@selector(privacyAction)];

    [self.view addSubview:self.addPhotoBtn];
    [self createUI];
    [self loadData];
    if (!self.isRemove) {
        [self.view addSubview:self.bannerView1];
        [self.bannerView1 loadRequest:[GADRequest request]];
        
        [self.view addSubview:self.bannerView2];
        [self.bannerView2 loadRequest:[GADRequest request]];
        [self loadInterstitial];
    }

}

- (PurchaseView *)purchaseView
{
    if (_purchaseView == nil) {
        if ([Utils getIsIpad]) {
            _purchaseView = [[PurchaseView alloc]initWithFrame:CGRectMake(0, 0, 400, 400)];

        } else {
            _purchaseView = [[PurchaseView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

        }
//        _successView.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:242.0/255.0 blue:236.0/255.0 alpha:1.0];
        _purchaseView.rootVc = self;
        [_purchaseView.homeButton addTarget:self action:@selector(oneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_purchaseView.gradButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _purchaseView;
}

- (void)privacyAction
{
    
    WebViewVC *vc = [[WebViewVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)oneAction:(UIButton *)sender
{
    if ([IAPManager canMakePayments]) {
        [[IAPManager sharedInstance]requestProductsId:@"remove_all_puzzle_ads" success:^(NSString * _Nonnull receiptStr) {
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"remove_ads"];
                } fail:^(NSString * _Nonnull errorMsg) {
                    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"remove_ads"];

                }];
    }
    
}

- (void)nextAction:(UIButton *)sender
{
    if ([IAPManager canMakePayments]) {
        
        [[IAPManager sharedInstance] requestProductsId:@"remove_ads_puzzle_mon" success:^(NSString * _Nonnull receiptStr) {
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"remove_ads"];

                } fail:^(NSString * _Nonnull errorMsg) {
                    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"remove_ads"];

                }];
    }
    
}


- (void)loadInterstitial {
    self.interstitial = nil;
    
  GADRequest *request = [GADRequest request];
  [GADInterstitialAd
       loadWithAdUnitID:@"ca-app-pub-7962668156781439/3451282540"
                request:request
      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
          NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
          return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
      }];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.fftoast show];
    if (self.interstitial) {
//      [self.interstitial presentFromRootViewController:self];
    }
}

- (GADBannerView *)bannerView1
{
    if (_bannerView1==nil) {
        _bannerView1 = [[GADBannerView alloc]initWithFrame:CGRectMake(0, 0, JLXScreenSize.width, 60)];
        _bannerView1.adUnitID = @"ca-app-pub-7962668156781439/1418578781";
        _bannerView1.rootViewController = self;
        
    }
    return _bannerView1;
}

- (GADBannerView *)bannerView2
{
    if (_bannerView2==nil) {
        _bannerView2 = [[GADBannerView alloc]initWithFrame:CGRectMake(0, 0, JLXScreenSize.width, 60)];
        _bannerView2.adUnitID = @"ca-app-pub-7962668156781439/4464131258";
        _bannerView2.rootViewController = self;
    }
    return _bannerView2;
}


//- (UICollectionView *)collectionView {
//    if (_collectionView == nil) {
//        CYLineLayout *cLineLayout = [[CYLineLayout alloc] init];
//        cLineLayout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width);
//        cLineLayout.minimumLineSpacing = 50;
//        cLineLayout.minimumInteritemSpacing = 50;
//
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - _addPhotoBtn.frame.origin.y) collectionViewLayout:cLineLayout];
//        
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        [_collectionView setPagingEnabled:true];
//        [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
//    }
//    return _collectionView;
//}

- (UIButton *)addPhotoBtn
{
    if (_addPhotoBtn == nil) {
        _addPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height - self.view.safeAreaInsets.bottom - 75, 65, 65)];
        [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        _addPhotoBtn.layer.shadowColor = [UIColor colorWithRed:232.0/255.0 green:163.0/255.0 blue:136/255.0 alpha:1.0].CGColor;
        _addPhotoBtn.layer.shadowOffset = CGSizeMake(0.f, 2.f);
        _addPhotoBtn.layer.shadowOpacity = 0.6f;

        [_addPhotoBtn addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _addPhotoBtn;;
}


- (void)viewDidLayoutSubviews
{
    _addPhotoBtn.frame =  CGRectMake(0, UIScreen.mainScreen.bounds.size.height - self.view.safeAreaInsets.bottom - 75, 65, 65);
    _addPhotoBtn.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, _addPhotoBtn.center.y);
    _collectionView.frame = CGRectMake(0, self.view.safeAreaInsets.top, UIScreen.mainScreen.bounds.size.width,UIScreen.mainScreen.bounds.size.height - self.view.safeAreaInsets.bottom - self.view.safeAreaInsets.top - 75);
    self.bannerView1.frame = CGRectMake(0, self.view.safeAreaInsets.top, JLXScreenSize.width, 60);
    self.bannerView2.frame = CGRectMake(0, JLXScreenSize.height - self.view.safeAreaInsets.bottom - 145, JLXScreenSize.width, 60);
}

-(void)createUI{
    CYLineLayout *layout = [[CYLineLayout alloc] init];
//    layout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width*kJLXWidthScale, UIScreen.mainScreen.bounds.size.width*kJLXWidthScale);
    layout.itemSize = CGSizeMake(474*kJLXWidthScale, 848*kJLXHeightScale);

    layout.minimumLineSpacing = 50*kJLXWidthScale;
    layout.minimumInteritemSpacing = 50*kJLXWidthScale;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:kJLXBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
    [self.view addSubview:self.collectionView];

    [self.collectionView setFrame:CGRectMake(0, 40*kJLXHeightScale, JLXScreenSize.width, JLXScreenSize.height)];
    self.collectionView.contentSize = CGSizeMake(self.imageArray.count*JLXScreenSize.width, 0);
}

-(void)loadData{

    self.imageArray = [NSMutableArray array];
    ///加四次为了循环
    for (int i=1; i<=71; i++) {
        [self.imageArray addObject:[NSString stringWithFormat:@"S%d",i]];
    }
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    /*[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageArray.count/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO]*/;
//    self.m_currentIndex = self.imageArray.count/2;
}
//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.view.bounds.size.width/20.0f;
    if (self.m_dragStartX -  self.m_dragEndX >= dragMiniDistance) {
        self.m_currentIndex -= 1;//向右
    } else if(self.m_dragEndX -  self.m_dragStartX >= dragMiniDistance){
        self.m_currentIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    
    self.m_currentIndex = self.m_currentIndex <= 0 ? 0 : self.m_currentIndex;
    self.m_currentIndex = self.m_currentIndex >= maxIndex ? maxIndex : self.m_currentIndex;
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)setAction
{
    
    [self.purchaseView showWithView:self.view];
    
}

//添加相册图片
- (void)addPhotos:(id)sender {
    UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choiceUploadType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"PhotoLibrary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choiceUploadType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alerVC addAction:action1];
    [alerVC addAction:action2];
    [alerVC addAction:action3];
    alerVC.popoverPresentationController.sourceView = self.view;
    alerVC.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 0, 0);


    [[[[UIApplication sharedApplication]delegate] window].rootViewController presentViewController:alerVC animated:YES completion:nil];
}

- (void)startPuzzle:(UIImage *)image index:(NSInteger)index
{
    UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"简单", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startPuzzle:image grade:3 index:index];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"正常", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startPuzzle:image grade:6 index:index];

    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"困难", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startPuzzle:image grade:10 index:index];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alerVC addAction:action1];
    [alerVC addAction:action2];
    [alerVC addAction:action3];
    [alerVC addAction:cancel];
    alerVC.popoverPresentationController.sourceView = self.view;
    alerVC.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 0, 0);

    [self presentViewController:alerVC animated:YES completion:nil];
}


//开始拼图
- (void)startPuzzle:(UIImage *)image grade:(NSInteger)grade index:(NSInteger)index {
    PuzzleViewController *vc = [[PuzzleViewController alloc] init];
    vc.pieceVCount = grade;
    vc.pieceHCount = grade;
    vc.originalCatImage = image;
    vc.index = index;
    vc.imageArray = self.imageArray;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)changeRowNum:(id)sender {
    self.rowNum_lb.text = [NSString stringWithFormat:@"Row:%ld", (NSInteger)self.rowSlider.value];
}

- (void)changeColumnNum:(id)sender {
    
    self.columnNum_lb.text = [NSString stringWithFormat:@"Column:%ld", (NSInteger)self.columnSlider.value];
}

- (void)choiceUploadType:(NSInteger )type {
    //权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        NSString * title = @"Album or camera permissions are not turned on";
        NSString * msg = @"Please open the application album or camera service in System Settings\n(Settings -> Privacy -> Album or Camera -> On)";
        NSString * cancelTitle = @"OK";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = type;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self startPuzzle:image index:-1];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ImageCell alloc] init];
    }
    [cell setCImage: [self.imageArray objectAtIndex:indexPath.row]];
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //自定义item的UIEdgeInsets
    return UIEdgeInsetsMake(0, self.view.bounds.size.width/2.0-474*kJLXWidthScale/2, 0, self.view.bounds.size.width/2.0-474*kJLXWidthScale/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self startPuzzle:[UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.item]] index:indexPath.item];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return _imageArray.count;
}

//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.m_dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.m_dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    if (self.m_currentIndex == [self.imageArray count]/4*3) {
//        NSIndexPath *path  = [NSIndexPath indexPathForItem:[self.imageArray count]/2 inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//        self.m_currentIndex = [self.imageArray count]/2;
//    }
//    else if(self.m_currentIndex == [self.imageArray count]/4){
//        NSIndexPath *path = [NSIndexPath indexPathForItem:[self.imageArray count]/2 inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//        self.m_currentIndex = [self.imageArray count]/2;
//    }
}


- (void)ad:(id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
    [self loadInterstitial];

}

- (void)adWillDismissFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    [self loadInterstitial];
}

- (void)adWillPresentFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    
}

- (void)adDidDismissFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    
}


@end



@implementation ImageCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];

    }
    return self;
}

- (void)setUpUI
{
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor colorWithRed:232.0/255.0 green:163.0/255.0 blue:136/255.0 alpha:1.0].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.f, 2.f);
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowRadius = 5.f;
    [self addSubview:self.cellImageView];
    [self addSubview:self.uLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.uLabel removeFromSuperview];
    });
}

- (void)setCImage:(NSString *)imageName
{
    self.cellImageView.image = [UIImage imageNamed:imageName];
}


- (UIImageView *)cellImageView
{
    if (_cellImageView == nil) {
        _cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        _cellImageView.layer.masksToBounds = YES;
        _cellImageView.layer.cornerRadius = 8.f;
        [_cellImageView setCenter:CGPointMake(_cellImageView.center.x, self.frame.size.height/2)
        ];
        _cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        //        _cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 474*kJLXWidthScale, 848*kJLXHeightScale)];

    }
    return  _cellImageView;
}

- (UILabel *)uLabel
{
    if (_uLabel == nil) {
        _uLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.cellImageView.frame.origin.y - 30, self.frame.size.width, 30)];
        _uLabel.backgroundColor = UIColor.clearColor;
        _uLabel.font = [UIFont systemFontOfSize:14];
        _uLabel.textColor = UIColor.grayColor;
        _uLabel.textAlignment = NSTextAlignmentCenter;
        [_uLabel setCenter:CGPointMake(_uLabel.center.x, self.frame.size.height/2 - self.cellImageView.bounds.size.height/2 - 30)];
        _uLabel.text = NSLocalizedString(@"左右滑动更精彩", nil);
    }
    return _uLabel;
}

@end
