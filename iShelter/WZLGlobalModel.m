//
//  WZLGlobalModel.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "WZLGlobalModel.h"
#import "NSString+WZLPaging.h"
@implementation WZLGlobalModel

+ (instancetype)sharedModel {
    //确保只执行一次
    static WZLGlobalModel *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[WZLGlobalModel alloc] init];
    });
    return model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //默认字体大小17
        self.fontSize = 17;
    }
    return self;
}

#pragma mark custom method

//字符串分割完成后执行回调Block
- (void)loadText:(NSString *)text completion:(void (^)(void))completion {
    self.text = text;
    [self pagingTextCompletion:completion];
}

- (void)pagingTextCompletion:(void (^)(void))completion
{
    NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithCapacity:5];
    UIFont * font = [UIFont systemFontOfSize:self.fontSize];
    [attributes setValue:font forKey:NSFontAttributeName];
    [attributes setValue:@(1.0) forKey:NSKernAttributeName];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;
    paragraphStyle.paragraphSpacing = 10.0;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    self.attributes = [attributes copy];
    self.rangeArray = [[self.text pageWithAttributes:self.attributes constrainToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10*2, [UIScreen mainScreen].bounds.size.height - 40*2)] mutableCopy];
    if (completion) {
        completion();
    }
}

- (void)updateFontCompletion:(void (^)(void))completion {
    
    NSRange range = self.currentRange;
    
    [self pagingTextCompletion:^{
        //重新定位页码
        [self.rangeArray enumerateObjectsUsingBlock:^(NSString *rangeStr, NSUInteger idx, BOOL *stop) {
            NSRange tempRange = NSRangeFromString(rangeStr);
            if (tempRange.location <= range.location && tempRange.location + tempRange.length > range.location) {
                self.currentPage = idx;
                *stop = YES;
            }
        }];
        if (completion) {
            completion();
        }
    }];
}

//#warning bugtofix 增大文字会超出界限一次 fixed
#pragma mark setter
- (void)setFontSize:(CGFloat)fontSize {
    if (fontSize < 12.0) {
        _fontSize = 12.0;
    }else if (_fontSize > 30){
        _fontSize = 30;
    }else{
        _fontSize = fontSize;
    }
}

- (void)setCurrentRange:(NSRange)currentRange {
    _currentRange = currentRange;
}
@end
