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
#import "WZLDataUtils.h"
#import "MBProgressHUD.h"

static NSString *lastRead = @"lastRead";
static NSString *Book = @"bookName";
static NSString *kOpenBookName = @"openBookName";
static NSString *kShowBookMarkPage = @"showBookMarkPage";

@interface PageViewController ()<FontAdjustDelegate,UIPageViewControllerDelegate>

@property (strong, nonatomic) PageModelViewController *modelController;
@property (strong, nonatomic) WZLGlobalModel *globalModel;

@property (strong, nonatomic) NSString *bookName;
@property (strong, nonatomic) UIButton *clickMiddleForMenu;
@property (strong, nonatomic) UIButton *coverMiddle;
@property (strong, nonatomic) TopMenu *topMenu;
@property (strong, nonatomic) BottomMenu *bottomMenu;
@property (assign, nonatomic) BOOL menuIsShow;
@property (assign, nonatomic) BOOL isNightMode;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuIsShow = NO;
    self.isNightMode = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealNotification:) name:kShowBookMarkPage object:nil];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *content = [NSString stringWithContentsOfFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",self.bookName]] encoding:NSUTF8StringEncoding error:nil];
    [self loadText:content];
    
    
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

- (IBAction)backToBook:(UIStoryboardSegue *)sender {
    
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
    //提供最近阅读的选项，方便封面变化
    [[NSUserDefaults standardUserDefaults] setObject:self.bookName forKey:@"recentRead"];
    /*返回书架，并且在返回时保存读书位置*/
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    NSNumber *font = [NSNumber numberWithInt:[WZLGlobalModel sharedModel].fontSize];
    NSNumber *page = [NSNumber numberWithInteger:[WZLGlobalModel sharedModel].currentPage];
    NSDictionary *book = @{@"name":self.bookName,@"font":font,@"page":page,@"lastread":destDateString};
    [[WZLDataUtils sharedDataUtils] updateBook:book];
    [self performSegueWithIdentifier:@"backToShelter" sender:nil];
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

- (void)addBookMark {
    NSNumber *page = [NSNumber numberWithInteger:[WZLGlobalModel sharedModel].currentPage];
    NSDictionary *dic = @{@"name":self.bookName,@"page":page};
    [[WZLDataUtils sharedDataUtils] insertBookMark:dic];
    UIViewController *vc = self.viewControllers[0];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok"]];
    hud.labelText = @"添加完成";
    [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
    
}

- (void)watchBookMark {
    [self performSegueWithIdentifier:@"watchBookMark" sender:nil];
}

- (void)watchReserved {
    [self performSegueWithIdentifier:@"watchReserved" sender:nil];
}

- (void)dealNotification:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    NSNumber *page = dic[@"page"];
    [WZLGlobalModel sharedModel].currentPage = page.intValue;
    [self setPageIndex:[WZLGlobalModel sharedModel].currentPage ];
    [self.view bringSubviewToFront:self.clickMiddleForMenu];
    [self.view bringSubviewToFront:self.topMenu];
    [self.view bringSubviewToFront:self.bottomMenu];
    [self.view bringSubviewToFront:self.coverMiddle];
}

- (void)changeReadMode:(UISwitch *) onoff{
    [[WZLGlobalModel sharedModel] updateNightMode:onoff.on completion:^{
        self.modelController.isNight = [WZLGlobalModel sharedModel].isNightMode;
        [self setPageIndex:[WZLGlobalModel sharedModel].currentPage];
        [self.view bringSubviewToFront:self.clickMiddleForMenu];
        [self.view bringSubviewToFront:self.topMenu];
        [self.view bringSubviewToFront:self.bottomMenu];
        [self.view bringSubviewToFront:self.coverMiddle];
    }];

    self.isNightMode = !self.isNightMode;
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
        _coverMiddle = [[UIButton alloc] initWithFrame:CGRectMake(0, 58, [UIScreen mainScreen].applicationFrame.size.width, self.view.frame.size.height - 58 - 44)];
        _coverMiddle.backgroundColor = [UIColor clearColor];
    }
    return _coverMiddle;
}

- (BottomMenu *)bottomMenu {
    if (!_bottomMenu) {
        _bottomMenu = [BottomMenu bottomMenu];
        _bottomMenu.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44);
    }
    return _bottomMenu;
}

- (NSString *)bookName {
    if (!_bookName) {
        _bookName = [[NSUserDefaults standardUserDefaults] objectForKey:Book];
    }
    return _bookName;
}

#pragma mark implementation method
- (void)loadText:(NSString *)text {
    //确保每次打开的书本字体不受前一次影响
    NSDictionary *book = [[WZLDataUtils sharedDataUtils] getBookByName:self.bookName];
     [WZLGlobalModel sharedModel].fontSize = 17;
    if (book != nil) {
        NSNumber *font = book[@"font"];
        NSNumber *page = book[@"page"];
        [WZLGlobalModel sharedModel].fontSize = font.intValue;
        [WZLGlobalModel sharedModel].currentPage = page.intValue;
    }
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

//截屏代码
- (UIImage *) captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark menuView
- (void)setUpTopMenu {
    
    [self.topMenu.nightSwitch addTarget:self action:@selector(changeReadMode:) forControlEvents:UIControlEventValueChanged];
    [self.topMenu.smallerFont addTarget:self action:@selector(smallerFontAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topMenu.biggerFont addTarget:self action:@selector(biggerFontAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.topMenu];
    [self.bottomMenu.backBtn addTarget:self action:@selector(backToShelter) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomMenu.chosePage addTarget:self action:@selector(watchBookMark) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomMenu.bookMark addTarget:self action:@selector(addBookMark) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomMenu.reserve addTarget:self action:@selector(watchReserved) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomMenu];
}

- (void)hideMenu {
    [self.coverMiddle removeFromSuperview];
    self.menuIsShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.topMenu.frame = CGRectMake(0, -58, self.topMenu.bounds.size.width, self.topMenu.bounds.size.height);
        self.bottomMenu.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].applicationFrame.size.width, 44);
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
        self.bottomMenu.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44);
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
    self.bottomMenu.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].applicationFrame.size.width, 44);
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

#pragma mark UIStoryboard
@end
