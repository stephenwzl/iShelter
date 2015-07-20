//
//  CollectionViewCell.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.bookTitle.layer.cornerRadius = 2;
    self.bookTitle.clipsToBounds = YES;
}

@end
