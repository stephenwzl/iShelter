//
//  PageViewController.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "PageViewController.h"
#import "PageModelViewController.h"
#import "WZLGlobalModel.h"
#import "PageDataViewController.h"
#import "TopMenu.h"
#import "BottomMenu.h"
@interface PageViewController ()<FontAdjustDelegate,UIPageViewControllerDelegate>

@property (strong, nonatomic)PageModelViewController *modelController;
@property (strong, nonatomic)WZLGlobalModel *globalModel;

@property (strong, nonatomic)UIButton *clickMiddleForMenu;
@property (strong, nonatomic)UIButton *coverMiddle;
@property (strong, nonatomic)TopMenu *topMenu;
@property (strong, nonatomic)BottomMenu *bottomMenu;
@property (assign, nonatomic)BOOL menuIsShow;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuIsShow = NO;
    
    NSString *bookName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookName"];
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:bookName ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    [self loadText:content];
    
    
    PageDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0];
    [self setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.dataSource = self.modelController;
    self.delegate = self;
    [self setUpButton];
    [self setUpTopMenu];
    
    self.fontdelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(hideMenu) withObject:nil afterDelay:0.5];
}
- (void)setUpButton {
    
    [self.clickMiddleForMenu addTarget:self action:@selector(clickMiddleFormenuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clickMiddleForMenu];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_clickMiddleForMenu(40)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_clickMiddleForMenu)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_clickMiddleForMenu]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_clickMiddleForMenu)]];
}

#pragma mark SEL
- (void)clickMiddleFormenuAction {
    if (self.menuIsShow) {
        self.menuIsShow = NO;
        [self hideMenu];
    }else{
        [self showMenu];
        self.menuIsShow = YES;
    }
}

- (void)backToShelter {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)smallerFontAction {
    [WZLGlobalModel sharedModel].fontSize -= 2;
    if ([self.fontdelegate respondsToSelector:@selector(adjustRangeArrayForText)]) {
        [self.fontdelegate adjustRangeArrayForText];
    }
}

- (void)biggerFontAction {
    CGFloat size = [WZLGlobalModel sharedModel].fontSize;
    size +=2;
    if (size > 30.0) {
        size = 30.0;
    }
    [WZLGlobalModel sharedModel].fontSize = size;
    if ([self.fontdelegate respondsToSelector:@selector(adjustRangeArrayForText)]) {
        [self.fontdelegate adjustRangeArrayForText];
    }
}

#pragma mark lazy load
- (PageModelViewController *)modelController {
    if (!_modelController) {
        _modelController = [[PageModelViewController alloc] init];
    }
    return _modelController;
}

- (WZLGlobalModel *)globalModel {
    if (_globalModel == nil) {
        _globalModel = [WZLGlobalModel sharedModel];
    }
    return _globalModel;
}

- (UIButton *)clickMiddleForMenu {
    if (!_clickMiddleForMenu) {
        _clickMiddleForMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickMiddleForMenu.backgroundColor = [UIColor clearColor];
        _clickMiddleForMenu.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _clickMiddleForMenu;
}

- (TopMenu *)topMenu {
    if (!_topMenu) {
        _topMenu = [TopMenu topMenu];
        _topMenu.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 58);
    }
    return _topMenu;
}

- (UIButton *)coverMiddle {
    if (!_coverMiddle) {
        _coverMiddle = [[UIButton alloc] initWithFrame:CGRectMake(0, 58, [UIScreen mainScreen].applicationFrame.size.width, self.view.frame.size.height - 58*2)];
        _coverMiddle.backgroundColor = [UIColor clearColor];
    }
    return _coverMiddle;
}

- (BottomMenu *)bottomMenu {
    if (!_bottomMenu) {
        _bottomMenu = [BottomMenu bottomMenu];
        _bottomMenu.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 58, [UIScreen mainScreen].bounds.size.width, 58);
    }
    return _bottomMenu;
}

#pragma mark implementation method
- (void)loadText:(NSString *)text {
    //确保每次打开的书本字体不受前一次影响
    [WZLGlobalModel sharedModel].fontSize = 17;
    [self.globalModel loadText:text completion:^{
        self.modelController.text = self.globalModel.text;
        self.modelController.attributes = self.globalModel.attributes;
        self.modelController.pageData = self.globalModel.rangeArray;
        
        [self setPageIndex:[WZLGlobalModel sharedModel].currentPage];
    }];
}

- (void)setPageIndex:(NSUInteger)index {
    [self setViewControllers:@[[self.modelController viewControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


#pragma mark menuView
- (void)setUpTopMenu {
    
    [self.topMenu.backToShelter addTarget:self action:@selector(backToShelter) forControlEvents:UIControlEventTouchUpInside];
    [self.topMenu.smallerFont addTarget:self action:@selector(smallerFontAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topMenu.biggerFont addTarget:self action:@selector(biggerFontAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.topMenu];
    [self.bottomMenu.backBtn addTarget:self action:@selector(backToShelter) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomMenu.reserve addTarget:self action:<#(SEL)#> forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomMenu.bookMark addTarget:self action:<#(SEL)#> forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.bottomMenu];
}

- (void)hideMenu {
    [self.coverMiddle removeFromSuperview];
    self.menuIsShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.topMenu.frame = CGRectMake(0, -58, self.topMenu.bounds.size.width, self.topMenu.bounds.size.height);
        self.bottomMenu.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].applicationFrame.size.width, 58);
    } completion:^(BOOL finished){
        self.topMenu.hidden = YES;
        self.bottomMenu.hidden = YES;
    }];
}

- (void)showMenu {

    [self.view addSubview:self.coverMiddle];
    [self.coverMiddle addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    self.menuIsShow = YES;
     self.topMenu.hidden = NO;
    self.bottomMenu.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.topMenu.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 58);
        self.bottomMenu.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 58, [UIScreen mainScreen].bounds.size.width, 58);
    } completion:^(BOOL finished){
       
    }];
}

#pragma mark fontadjustdelegate

- (void)adjustRangeArrayForText {
    [[WZLGlobalModel sharedModel]updateFontCompletion:^{
        self.modelController.text = self.globalModel.text;
        self.modelController.attributes = self.globalModel.attributes;
        self.modelController.pageData = self.globalModel.rangeArray;
        [self setPageIndex:[WZLGlobalModel sharedModel].currentPage];
        [self.view bringSubviewToFront:self.clickMiddleForMenu];
        [self.view bringSubviewToFront:self.topMenu];
        [self.view bringSubviewToFront:self.bottomMenu];
        [self.view bringSubviewToFront:self.coverMiddle];
    }];
}

#pragma mark pageviewcontrollerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    self.topMenu.frame = CGRectMake(0, -58, [UIScreen mainScreen].applicationFrame.size.width, 58);
    self.topMenu.hidden = YES;
    self.bottomMenu.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].applicationFrame.size.width, 58);
    self.bottomMenu.hidden = YES;
    self.menuIsShow = NO;
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIViewController *currentViewController = self.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}
@end
