//
//  TopMenu.m
//  iShelter
//
//  Created by wangzhilong on 15/7/21.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "TopMenu.h"

@implementation TopMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)topMenu {
    TopMenu *topMenu = [[NSBundle mainBundle] loadNibNamed:@"TopMenu" owner:self options:nil][0];
    return topMenu;
}
@end
