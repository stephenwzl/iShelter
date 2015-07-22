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
@interface ReservedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *reserves;
@property (strong, nonatomic) ReservedTableViewCell *protocolCell;
@end

@implementation ReservedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reserves.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReservedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reserved"];
    cell.titleLabel.text = self.reserves[indexPath.row][@"name"];
    cell.contentLabel.text = self.reserves[indexPath.row][@"content"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReservedTableViewCell *cell = self.protocolCell;
    cell.titleLabel.text = self.reserves[indexPath.row][@"name"];
    cell.contentLabel.text = self.reserves[indexPath.row][@"content"];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1 + size.height;
    
}

- (NSMutableArray *)reserves {
    if (!_reserves) {
        _reserves = [[WZLDataUtils sharedDataUtils] getReserveByName:[[NSUserDefaults standardUserDefaults] objectForKey:@"bookName"]];
    }
    return _reserves;
}

- (ReservedTableViewCell *)protocolCell {
    if (_protocolCell) {
        _protocolCell = [self.tableView dequeueReusableCellWithIdentifier:@"reserved"];
    }
    return _protocolCell;
}

@end
