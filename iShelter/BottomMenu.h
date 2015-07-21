//
//  BottomMenu.h
//  iShelter
//
//  Created by wangzhilong on 15/7/21.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomMenu : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *bookMark;
@property (weak, nonatomic) IBOutlet UIButton *chosePage;
@property (weak, nonatomic) IBOutlet UIButton *reserve;

+ (instancetype)bottomMenu;
@end
