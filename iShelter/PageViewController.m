//
//  PageViewController.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "PageViewController.h"
#import "PageModelViewController.h"
#import "WZLGlobalModel.h"
#import "PageDataViewController.h"

@interface PageViewController ()

@property (strong, nonatomic)PageModelViewController *modelController;
@property (strong, nonatomic)WZLGlobalModel *globalModel;


@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *bookName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookName"];
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"左耳" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    [self loadText:content];
    PageDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0];
    [self setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.dataSource = self.modelController;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark lazy load
- (PageModelViewController *)modelController {
    if (!_modelController) {
        _modelController = [[PageModelViewController alloc] init];
    }
    return _modelController;
}

- (WZLGlobalModel *)globalModel {
    if (_globalModel == nil) {
        _globalModel = [WZLGlobalModel sharedModel];
    }
    return _globalModel;
}

#pragma mark implementation method
- (void)loadText:(NSString *)text {
    [self.globalModel loadText:text completion:^{
        self.modelController.text = self.globalModel.text;
        self.modelController.attributes = self.globalModel.attributes;
        self.modelController.pageData = self.globalModel.rangeArray;
        [self setPageIndex:[WZLGlobalModel sharedModel].currentPage];
    }];
}

- (void)setPageIndex:(NSUInteger)index {
    [self setViewControllers:@[[self.modelController viewControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
@end
