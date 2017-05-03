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
    
    PussBannerView *banner = [PussBannerView bannerWithFrame:CGRectMake(0, 0, KScreenWidth, 180) imageNameGroup:@[@"4", @"5"] shouldUnlimitedLoop:YES];
    banner.isUnlimitedLoop = NO;
    banner.pageAlignment = PussPageControlAlignmentCenter;
    banner.currentDotColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    banner.dotColor = [UIColor lightTextColor];
    banner.showPageControl = YES;
//    banner.direction = UICollectionViewScrollDirectionVertical;
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
    
    NSLog(@"改变");
}

@end
