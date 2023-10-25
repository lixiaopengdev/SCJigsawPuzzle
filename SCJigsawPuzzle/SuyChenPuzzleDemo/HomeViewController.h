//
//  HomeViewController.h
//  SuyChenPuzzleDemo
//
//  Created by CSY on 2019/2/20.
//  Copyright © 2019 suychen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@end


@interface ImageCell : UICollectionViewCell
@property (nonatomic ,strong)UIImageView *cellImageView;
- (void)setCImage:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
