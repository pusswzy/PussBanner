//
//  PussBannerView.m
//  PussBanner
//
//  Created by 李昊泽 on 17/4/25.
//  Copyright © 2017年 李昊泽. All rights reserved.
//

#import "PussBannerView.h"
#import "PussCollectionViewCell.h"

#define KPussPageControlInitialDotSize CGSizeMake(10, 10)
#define KCommonMargin 10.0

static NSString * const cellID = @"pussCellID";

@interface PussBannerView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    UICollectionViewFlowLayout *_flowLayout;
    UICollectionView *_mainView;
    UIPageControl *_pageControl;
    NSInteger _itemCount;
}
/** 轮播图片数组  */
@property (nonatomic, strong) NSArray *imagePathsGroup;
/** 是否为无限轮播  */
@property (nonatomic, assign) BOOL isUnlimitedLoop;
@end


@implementation PussBannerView

#pragma mark - initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self setUpMainView];
    }
    return self;
}

+ (instancetype)bannerWithFrame:(CGRect)frame imageNameGroup:(NSArray *)imageNameGroup shouldUnlimitedLoop:(BOOL)unlimitedLoop
{
    PussBannerView *bannerView = [[self alloc] initWithFrame:frame];
    bannerView.backgroundColor = [UIColor lightGrayColor];
    bannerView.localizationImageNameArray = [imageNameGroup copy];
    bannerView.isUnlimitedLoop = unlimitedLoop;
    return bannerView;
}

- (void)initial
{
    self.pageAlignment = PussPageControlAlignmentCenter;
    self.currentDotColor = [UIColor blueColor];
    self.dotColor = [UIColor lightGrayColor];
    self.showPageControl = YES;
    self.hidesForSinglePage = NO;
}

//添加包含banner的collectionView
- (void)setUpMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.scrollsToTop = NO;
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.delegate = self;
    mainView.dataSource = self;
    [mainView registerClass:[PussCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    _mainView = mainView;
    [self addSubview:mainView];
}

- (void)setUpPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    _pageControl = pageControl;
    pageControl.pageIndicatorTintColor = self.dotColor;
    pageControl.currentPageIndicatorTintColor = self.currentDotColor;
    pageControl.numberOfPages = self.imagePathsGroup.count;
    pageControl.userInteractionEnabled = NO;
    
    [self addSubview:pageControl];
}

#pragma mark - set method
- (void)setLocalizationImageNameArray:(NSArray *)localizationImageNameArray
{
    _localizationImageNameArray = localizationImageNameArray;
    self.imagePathsGroup = [_localizationImageNameArray copy];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup
{
    _imagePathsGroup = imagePathsGroup;
    
    _itemCount = _isUnlimitedLoop == YES ? imagePathsGroup.count * 50 : imagePathsGroup.count;
    [_mainView reloadData];
    
    [self setUpPageControl];
    
}

- (void)setIsUnlimitedLoop:(BOOL)isUnlimitedLoop
{
    _isUnlimitedLoop = isUnlimitedLoop;
    
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup; //为了调用imagePathsGroup的set方法, 防止因初始化先后顺序, 导致isUnlimitedLoop失效
    }
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    
    _pageControl.hidden = !showPageControl;
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    _hidesForSinglePage = hidesForSinglePage;
    
    _pageControl.hidesForSinglePage = hidesForSinglePage;
}

- (void)setCurrentDotColor:(UIColor *)currentDotColor
{
    _currentDotColor = currentDotColor;
    
    _pageControl.currentPageIndicatorTintColor = currentDotColor;
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    
    _pageControl.pageIndicatorTintColor = dotColor;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PussCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    long itemPathIndex = indexPath.item % self.imagePathsGroup.count;
    NSString *imagePath = self.imagePathsGroup[itemPathIndex];
    
    //增加容错性
    if ([imagePath isKindOfClass:[NSString class]]) {
        UIImage *image = [UIImage imageNamed:imagePath];
        if (!image) {
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
        cell.imageView.image = image;
    }
    
    if ([imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    return cell;
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    _mainView.frame = self.bounds;
    
    if (_mainView.contentOffset.x == 0 && _itemCount) {
        int targetIndex = 0;
        
        if (self.isUnlimitedLoop == YES) {
            targetIndex = _itemCount * 0.5;
        } else {
            targetIndex = 0;
        }
        
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    //设置pageControl的位置
    CGSize pageSize = CGSizeZero;
    pageSize = CGSizeMake(KPussPageControlInitialDotSize.width * self.imagePathsGroup.count * 1.5, KPussPageControlInitialDotSize.height);
    CGFloat pageY = _mainView.frame.size.height - pageSize.height - KCommonMargin;
    CGFloat pageX = 0;
    if (self.pageAlignment == PussPageControlAlignmentCenter) {
        pageX = (_mainView.frame.size.width - pageSize.width) / 2;
    }
    
    if (self.pageAlignment == PussPageControlAlignmentLeft) {
        pageX = 0.0 + KCommonMargin;
    }
    
    if (self.pageAlignment == PussPageControlAlignmentRight) {
        pageX = _mainView.frame.size.width - pageSize.width - KCommonMargin;
    }
    _pageControl.frame = CGRectMake(pageX, pageY, pageSize.width, pageSize.height);
    
    NSLog(@"调用了layout subview");
}

@end
