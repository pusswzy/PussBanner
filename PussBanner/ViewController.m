//
//  ViewController.m
//  PussBanner
//
//  Created by 李昊泽 on 17/4/25.
//  Copyright © 2017年 李昊泽. All rights reserved.
//

#import "ViewController.h"
#import "PussBannerView.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()
/** banner  */
@property (nonatomic, strong) PussBannerView *banner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    PussBannerView *banner = [PussBannerView bannerWithFrame:CGRectMake(0, 0, KScreenWidth, 180) imageNameGroup:@[@"4", @"5", @"true.jpeg"] shouldUnlimitedLoop:YES];
    banner.isUnlimitedLoop = YES;
    banner.pageAlignment = PussPageControlAlignmentCenter;
    banner.currentDotColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    banner.dotColor = [UIColor lightTextColor];
    banner.showPageControl = YES;
//    banner.direction = UICollectionViewScrollDirectionVertical;
  //  banner.scrollTimeInterval = 0.2;
    self.banner = banner;
    [self.view addSubview:banner];
    
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //self.banner.frame = CGRectMake(0, 0, KScreenWidth, 180);
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
     self.banner.frame = CGRectMake(0, 0, KScreenWidth, 180);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    self.banner.direction = UICollectionViewScrollDirectionHorizontal;
    self.view = nil;
    [self.view removeFromSuperview];
    NSLog(@"改变");
}

@end
