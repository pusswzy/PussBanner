//
//  PussCollectionViewCell.m
//  PussBanner
//
//  Created by 李昊泽 on 17/4/25.
//  Copyright © 2017年 李昊泽. All rights reserved.
//

#import "PussCollectionViewCell.h"

@implementation PussCollectionViewCell

#pragma mark - initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpImageView];
    }
    return self;
}

- (void)setUpImageView
{
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
}

#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}
@end
