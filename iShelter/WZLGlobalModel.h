//
//  WZLGlobalModel.h
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZLGlobalModel : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSMutableArray *rangeArray;
@property (strong, nonatomic) NSDictionary *attributes;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSRange currentRange;
@property (assign, nonatomic) BOOL isNightMode;

+ (instancetype)sharedModel;

- (void)loadText:(NSString *)text completion:(void(^)(void))completion;

- (void)updateFontCompletion:(void(^)(void))completion;

- (void)updateNightMode:(BOOL)isNight completion:(void (^)(void))completion;
@end
