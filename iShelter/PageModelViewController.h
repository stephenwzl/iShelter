//
//  PageModelViewController.h
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageDataViewController.h"
#import "PageViewController.h"
@interface PageModelViewController : NSObject <UIPageViewControllerDataSource>

//@property (weak, nonatomic)PageViewController *readerViewcontroller;
@property (strong, nonatomic)NSArray *pageData;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDictionary *attributes;

- (PageDataViewController *)viewControllerAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfViewController:(PageDataViewController *)viewcontroller;

@end
