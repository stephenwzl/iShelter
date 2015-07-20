//
//  NSString+WZLPaging.h
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSString (WZLPaging)
/* 对字符串根据给定的样式进行分页操作
 * 返回分页后的数组
 */

- (NSArray *)pageWithAttributes:(NSDictionary *)attributes constrainToSize:(CGSize)size;

@end
