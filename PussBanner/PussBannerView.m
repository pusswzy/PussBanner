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
/** 定时器  */
@property (nonatomic, strong) NSTimer *timer;
@end


@implementation PussBannerView

#pragma mark - initialization
- (instancetype)init
{
    if (self = [super init]) {
        [self initial];
        [self setUpMainView];
    }
    return self;
}

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
    self.direction = UICollectionViewScrollDirectionHorizontal;
    _autoScroll = YES;
    _scrollTimeInterval = 3.0;
}

//添加包含banner的collectionView
- (void)setUpMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = self.direction;
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

- (void)setUpTimer
{
    self.timer = [NSTimer timerWithTimeInterval:_scrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
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
    
    if (imagePathsGroup.count > 1) {
        [self setAutoScroll:_autoScroll];
        _mainView.scrollEnabled = YES;
    } else {
        _mainView.scrollEnabled = NO;
    }
    
    [_mainView reloadData];
    [self setUpPageControl];
    
}

- (void)setIsUnlimitedLoop:(BOOL)isUnlimitedLoop
{
    _isUnlimitedLoop = isUnlimitedLoop;
    
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup; //reload
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

- (void)setDirection:(UICollectionViewScrollDirection)direction
{
    _direction = direction;
    
    _flowLayout.scrollDirection = direction;
    
    //修改flowLayout的scrollDirection会导致UICollectionView回滚到初始位置
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_itemCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    [self invalidTimer];
    
    if (autoScroll == YES) {
        [self setUpTimer];
    }
}

- (void)setScrollTimeInterval:(CGFloat)scrollTimeInterval
{
    _scrollTimeInterval = MAX(0.2, scrollTimeInterval);
    
    [self setAutoScroll:_autoScroll];
}

#pragma mark - public methop
- (void)adjustFrame
{
    //放弃
}

#pragma mark - private method
//获取当前轮播图的下标
- (NSInteger)getCurrentIndex
{
    
    if (_mainView.frame.size.height == 0 || _mainView.frame.size.width == 0) return 0;
    
    NSInteger currentIndex = 0;
    if (self.direction == UICollectionViewScrollDirectionHorizontal) {
        currentIndex = (_mainView.contentOffset.x / self.frame.size.width) + 0.5;

    }
    
    if (self.direction == UICollectionViewScrollDirectionVertical) {
        currentIndex = _mainView.contentOffset.y / self.frame.size.height + 0.5;
    }
    
    return MAX(0, currentIndex);
}

- (NSInteger)getCurrentPageWithCurrentItemIndex:(NSInteger)currentItemIndex
{
    return currentItemIndex % self.imagePathsGroup.count;
}

- (void)automaticScroll
{
    if (_itemCount == 0) return;
    NSInteger targetIndex = [self getCurrentIndex];
    targetIndex += 1;
    [self scrollToTargetIndex:targetIndex];
}

- (void)scrollToTargetIndex:(NSInteger)targetIndex
{
    if (targetIndex >= _itemCount) {
        if (self.isUnlimitedLoop) {
            targetIndex = _itemCount* 0.5;
             [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)invalidTimer
{
    [self.timer invalidate];
    self.timer = nil;
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

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(banner:didSelectItemAtIndex:)]) {
        [self.delegate banner:self didSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll == YES) {
        [self invalidTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = [self getCurrentPageWithCurrentItemIndex:[self getCurrentIndex]];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if (self.autoScroll == YES) {
        [self setUpTimer];
    }
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentInteger = [self getCurrentIndex];
    NSInteger page = [self getCurrentPageWithCurrentItemIndex:currentInteger];
    
    if ([self.delegate respondsToSelector:@selector(banner:didScrollToIndex:)]) {
        [self.delegate banner:self didScrollToIndex:page];
    }
}


#pragma mark - life cycles
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
    CGFloat pageY = self.frame.size.height - pageSize.height - KCommonMargin;
    CGFloat pageX = 0;
    if (self.pageAlignment == PussPageControlAlignmentCenter) {
        pageX = (self.frame.size.width - pageSize.width) / 2;
    }
    
    if (self.pageAlignment == PussPageControlAlignmentLeft) {
        pageX = 0.0 + KCommonMargin;
    }
    
    if (self.pageAlignment == PussPageControlAlignmentRight) {
        pageX = self.frame.size.width - pageSize.width - KCommonMargin;
    }
    _pageControl.frame = CGRectMake(pageX, pageY, pageSize.width, pageSize.height);
    
}

- (void)dealloc
{
    [self invalidTimer];
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

@end
