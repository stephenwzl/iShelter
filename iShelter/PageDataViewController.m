//
//  PageDataViewController.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "PageDataViewController.h"
#import "WZLGlobalModel.h"
#import "WZLDataUtils.h"
#import "MBProgressHUD.h"
@interface PageDataViewController ()

@end

@implementation PageDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.progressLabel];
    //auto layout
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_textView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_textView]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_progressLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_progressLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressLabel)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress) name:kUpdatePageNotification object:nil];
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(reserveText)];
    UIMenuController *mvc = [UIMenuController sharedMenuController];
    [mvc setMenuItems:@[menuItem]];
    
}

- (void)reserveText {
//    NSLog(@"%@",[self.textView.attributedText.string substringWithRange:self.textView.selectedRange]);
    NSDictionary *dic = @{@"name":[[NSUserDefaults standardUserDefaults] objectForKey:@"bookName"],@"content":[self.textView.attributedText.string substringWithRange:self.textView.selectedRange]};
    [[WZLDataUtils sharedDataUtils] insertReserves:dic];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"收藏成功";
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok"]];
    [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
    [self hightLightReserved];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView setText:[[NSAttributedString alloc] initWithString:self.dataObject attributes:self.attributes]];
    [self updateSkin];
    [self hightLightReserved];
    [self updateProgress];
}

- (void)updateSkin {
    
    if (self.isNight) {
        self.view.backgroundColor = [[UIColor alloc] initWithRed:(CGFloat)72/255 green:(CGFloat)72/255 blue:(CGFloat)72/255 alpha:1.0];
        self.textView.backgroundColor = [[UIColor alloc] initWithRed:(CGFloat)72/255 green:(CGFloat)72/255 blue:(CGFloat)72/255 alpha:1.0];
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        [attstr addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithRed:(CGFloat)200/255 green:(CGFloat)200/255 blue:(CGFloat)200/255 alpha:1.0] range:NSMakeRange(0, attstr.string.length)];
        self.textView.attributedText = attstr;
    }
}

- (void)hightLightReserved {
    NSMutableArray *reserved = [[WZLDataUtils sharedDataUtils] getReserveByName:[[NSUserDefaults standardUserDefaults] objectForKey:@"bookName"]];
    for (NSDictionary *dic in reserved) {
        NSString *highLighted = dic[@"content"];
        NSRange found = [self.textView.attributedText.string rangeOfString:highLighted];
        if (found.length > 0) {
            NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
            [attstring addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: found];
            self.textView.attributedText = attstring;
        }
    }
}


- (void)updateProgress {
    [self.progressLabel setText:[NSString stringWithFormat:@"%ld/%ld", (long)[WZLGlobalModel sharedModel].currentPage + 1, (long)self.totalPage]];
}
#pragma mark lazyload

- (WZLPageTextView *)textView {
    if (_textView == nil) {
        _textView = [[WZLPageTextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textView;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _progressLabel.font = [UIFont systemFontOfSize:12];
        _progressLabel.textColor = [UIColor blackColor];
        _progressLabel.backgroundColor = [UIColor clearColor];
    }
    return _progressLabel;
}


@end
