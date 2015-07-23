//
//  TopMenu.h
//  iShelter
//
//  Created by wangzhilong on 15/7/21.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopMenu : UIView

@property (weak, nonatomic) IBOutlet UISwitch *nightSwitch;

@property (weak, nonatomic) IBOutlet UIButton *smallerFont;
@property (weak, nonatomic) IBOutlet UIButton *biggerFont;

+ (instancetype)topMenu;
@end
