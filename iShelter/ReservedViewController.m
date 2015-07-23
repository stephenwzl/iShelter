//
//  ReservedViewController.m
//  iShelter
//
//  Created by wangzhilong on 15/7/22.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "ReservedViewController.h"
#import "WZLDataUtils.h"
#import "ReservedTableViewCell.h"
#import "NSString+WZLPaging.h"
static NSString *reuserID = @"reserved";
@interface ReservedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *reserves;
@property (strong, nonatomic) UITableViewCell *protocolCell;
@end

@implementation ReservedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //register Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ReservedTableViewCell" bundle:nil] forCellReuseIdentifier:reuserID];
     self.protocolCell = [self.tableView dequeueReusableCellWithIdentifier:reuserID];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    /*
     *重中之重！！！！
     *必须给 rowHeight 设置为此值才会自动计算高度！
     */
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reserves.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReservedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    cell.contentLabel.text = self.reserves[indexPath.row][@"content"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReservedTableViewCell *cell =(ReservedTableViewCell *) self.protocolCell;
    NSString *str = self.reserves[indexPath.row][@"content"];
    cell.contentLabel.text = str;
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[WZLDataUtils sharedDataUtils] deleteReserve:self.reserves[indexPath.row]];
    [self.reserves removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark lazy load

- (NSMutableArray *)reserves {
    if (!_reserves) {
        _reserves = [[WZLDataUtils sharedDataUtils] getReserveByName:[[NSUserDefaults standardUserDefaults] objectForKey:@"bookName"]];
    }
    return _reserves;
}



@end
