//
//  bookMarkViewController.m
//  iShelter
//
//  Created by wangzhilong on 15/7/22.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "bookMarkViewController.h"
#import "WZLDataUtils.h"

static NSString *kShowBookMarkPage = @"showBookMarkPage";

@interface bookMarkViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bookMarks;
@end

@implementation bookMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    [self.tableView setEditing:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exit:(id)sender {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookMarks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmark"];
    cell.textLabel.text = [NSString stringWithFormat:@"《%@》",self.bookMarks[indexPath.row][@"name"]];
    NSNumber *page = self.bookMarks[indexPath.row][@"page"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%d页",page.intValue + 1];
    return cell;
}




- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[WZLDataUtils sharedDataUtils] deleteBookMark:self.bookMarks[indexPath.row]];
        [self.bookMarks removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.bookMarks[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowBookMarkPage object:dic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark lazy load
- (NSMutableArray *)bookMarks {
    if (!_bookMarks) {
        NSString *bookName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookName"];
        _bookMarks = [[WZLDataUtils sharedDataUtils] getBookMarkByName:bookName];
    }
    return _bookMarks;
}
@end
