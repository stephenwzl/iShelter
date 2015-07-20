//
//  PageDataViewController.h
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZLPageTextView.h"
@interface PageDataViewController : UIViewController
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) WZLPageTextView *textView;
@property (strong, nonatomic) NSDictionary *attributes;

@property (assign, nonatomic) NSUInteger currentPage;
@property (assign, nonatomic) NSUInteger totalPage;

@end
