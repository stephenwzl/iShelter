//
//  WZLDataUtils.h
//  iShelter
//
//  Created by wangzhilong on 15/7/22.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZLDataUtils : NSObject

+ (instancetype)sharedDataUtils;

- (BOOL)insertBooks:(NSArray *)books;

- (NSDictionary *)getBookByName:(NSString *)bookName;
- (NSMutableArray *)getAllBooks;
- (void)updateBook:(NSDictionary *)book;

- (NSMutableArray *)getAllBookMark;
- (NSMutableArray *)getBookMarkByName:(NSString *)bookName;
- (void)insertBookMark:(NSDictionary *)dic;

- (void)insertReserves:(NSDictionary *)dic;
- (NSMutableArray *)getAllReserves;
@end
