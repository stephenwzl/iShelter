//
//  BottomMenu.m
//  iShelter
//
//  Created by wangzhilong on 15/7/21.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "BottomMenu.h"

@implementation BottomMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)bottomMenu {
    BottomMenu *menu = [[NSBundle mainBundle] loadNibNamed:@"BottomMenu" owner:self options:nil][0];
    return menu;
}
@end
