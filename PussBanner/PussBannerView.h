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

@class PussBannerView;

@protocol PussBannerDelegate <NSObject>

@optional
/** 点击图片回调 */
- (void)banner:(PussBannerView *)banner didSelectItemAtIndex:(NSInteger)selectIndex;
/** 手动滚动回调 */
- (void)banner:(PussBannerView *)banner didScrollToIndex:(NSInteger)index;
@end

@interface PussBannerView : UIView
/** 网络图片URL字符串数组  */
@property (nonatomic, strong) __deprecated NSArray *imageURLStringsGroup;

/** 本地图片名字数组  */
@property (nonatomic, strong) NSArray *localizationImageNameArray;

//** 代理 */
@property (nonatomic, weak) id<PussBannerDelegate> delegate;

/**********    pageControl     **********/

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




/**********    滚动控制     **********/

/** 轮播图滚动方向,默认UICollectionViewScrollDirectionHorizontal  */
@property (nonatomic, assign) UICollectionViewScrollDirection direction;
/** 是否为无限轮播,默认YES  */
@property (nonatomic, assign) BOOL isUnlimitedLoop;
/** 是否为自动滚动,默认YES  */
@property (nonatomic, assign) BOOL autoScroll;
/** 自动滚动时间间隔,默认3s,最小间隔0.2s */
@property (nonatomic, assign) CGFloat scrollTimeInterval;

/*** 废弃的初始化方法 ***/
- (instancetype)init __deprecated_msg("use bannerWithFrame method to initialize");
- (instancetype)initWithFrame:(CGRect)frame __deprecated_msg("use bannerWithFrame method to initialize");

/**********     初始化方法    **********/
+ (instancetype)bannerWithFrame:(CGRect)frame imageNameGroup:(NSArray *)imageNameGroup shouldUnlimitedLoop:(BOOL)unlimitedLoop;

/**********  public method   **********/
- (void)adjustFrame;


@end
