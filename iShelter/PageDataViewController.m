//
//  PageDataViewController.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "PageDataViewController.h"

@interface PageDataViewController ()

@end

@implementation PageDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    //auto layout
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_textView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_textView]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePage) name:kUpdatePageNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView setText:[[NSAttributedString alloc] initWithString:self.dataObject attributes:self.attributes]];
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


@end
