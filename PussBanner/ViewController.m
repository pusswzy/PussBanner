//
//  ViewController.m
//  PussBanner
//
//  Created by 李昊泽 on 17/4/25.
//  Copyright © 2017年 李昊泽. All rights reserved.
//

#import "ViewController.h"
#import "PussBannerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PussBannerView *banner = [PussBannerView bannerWithFrame:CGRectMake(0, 0, 375, 180) imageNameGroup:@[@"4", @"5", @"true.jpeg", @"true-2.jpeg"] shouldUnlimitedLoop:YES];
    banner.pageAlignment = PussPageControlAlignmentCenter;
    banner.currentDotColor = [UIColor orangeColor];
    banner.dotColor = [UIColor darkTextColor];
    banner.showPageControl = YES;
    [self.view addSubview:banner];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
