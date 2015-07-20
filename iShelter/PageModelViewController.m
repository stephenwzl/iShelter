//
//  PageModelViewController.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "PageModelViewController.h"
#import "WZLGlobalModel.h"
@interface PageModelViewController ()

@end

@implementation PageModelViewController
#pragma mark custom Method

- (PageDataViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (self.pageData.count == 0 || index >= self.pageData.count) {
        return nil;
    }
    PageDataViewController *dataViewController = [[PageDataViewController alloc] init];
    dataViewController.dataObject = [self.text substringWithRange:NSRangeFromString(self.pageData[index])];
    dataViewController.attributes = self.attributes;
    dataViewController.currentPage = index;
    dataViewController.totalPage = [self.pageData count];
    
    //告知全局模型当前页面位置，以便即时更新设置
    [WZLGlobalModel sharedModel].currentPage = index;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(PageDataViewController *)viewcontroller {
    return [self.pageData indexOfObject:NSStringFromRange([self.text rangeOfString:viewcontroller.dataObject])];
}

#pragma mark <DataSource Method>

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PageDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    [WZLGlobalModel sharedModel].currentRange = NSRangeFromString(self.pageData[index]);
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PageDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    [WZLGlobalModel sharedModel].currentRange = NSRangeFromString(self.pageData[index]);
    return [self viewControllerAtIndex:index];
}


@end
