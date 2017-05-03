//
//  PussBannerView.h
//  PussBanner
//
//  Created by 李昊泽 on 17/4/25.
//  Copyright © 2017年 李昊泽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PussPageControlAlignmentCenter,
    PussPageControlAlignmentRight,
    PussPageControlAlignmentLeft,
} PussPageControlAlignment;

@interface PussBannerView : UIView
/** 网络图片URL字符串数组  */
@property (nonatomic, strong) __deprecated NSArray *imageURLStringsGroup;

/** 本地图片名字数组  */
@property (nonatomic, strong) NSArray *localizationImageNameArray;


/*****    pageContro     *****/
/** pageController控件位置  */
@property (nonatomic, assign) PussPageControlAlignment pageAlignment;

/** 分页控件当前小圆标颜色  */
@property (nonatomic, strong) UIColor *currentDotColor;

/** 分页控件其它小圆标颜色  */
@property (nonatomic, strong) UIColor *dotColor;

/** 是否显示分页控件 default is YES */
@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;

/** 当只有一张图片时,是否隐藏分页控件 default is NO */
@property (nonatomic, assign, getter=isShowPageControl) BOOL hidesForSinglePage;




/*****    CollectionView     *****/
/** 轮播图滚动方向  */
@property (nonatomic, assign) UICollectionViewScrollDirection direction;
/** 是否为无限轮播  */
@property (nonatomic, assign) BOOL isUnlimitedLoop;

/*** 废弃的初始化方法 ***/
- (instancetype)init __deprecated_msg("use bannerWithFrame method to initialize");
- (instancetype)initWithFrame:(CGRect)frame __deprecated_msg("use bannerWithFrame method to initialize");

/*****     初始化方法    *****/
+ (instancetype)bannerWithFrame:(CGRect)frame imageNameGroup:(NSArray *)imageNameGroup shouldUnlimitedLoop:(BOOL)unlimitedLoop;

/*****  public method   *****/
- (void)adjustFrame;


@end
