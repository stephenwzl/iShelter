//
//  WZLPageTextView.h
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//
//自定义属性文字的绘制
#import <UIKit/UIKit.h>

@interface WZLPageTextView : UITextView
@property (copy, nonatomic) NSAttributedString *attString;

- (void)setText:(NSAttributedString *)text;

@end
