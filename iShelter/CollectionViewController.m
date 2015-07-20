//
//  CollectionViewController.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#pragma mark - works
//写一个简单小说阅读器项目，支持前后滑动翻页和点击翻页，能保存书签和上次阅读记录，长按画重点，
//改变字体大小等功能

#pragma mark - TODO 7.20
//重写UIView，实现属性文字绘制 CoreText 

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
@interface CollectionViewController ()

@property (strong, nonatomic) NSMutableArray *bookFiles;
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Register cell classes
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Register Nib
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    //configLayout
    [self configLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - lazyload
- (NSMutableArray *)bookFiles {
    if (_bookFiles == nil) {
//        [self getBooks];
        _bookFiles = [NSMutableArray arrayWithArray:@[@"沙漏",@"百年孤独",@"左耳",@"钢铁是怎样炼成的"]];
    }
    return _bookFiles;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSNumber *index = sender;
    [[NSUserDefaults standardUserDefaults] setObject:self.bookFiles[index.integerValue] forKey:@"bookName"];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //only one type of book in this App
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bookFiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.bookTitle.text = self.bookFiles[indexPath.item];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showBook" sender:[NSNumber numberWithInteger:indexPath.item]];
}

- (void)configLayout {
    CGFloat screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    CGFloat space = (screenWidth - 3 * 90) / 4;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(90, 120);
    flowLayout.minimumInteritemSpacing = space;
    flowLayout.minimumLineSpacing = 16;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, space, 10, space);
    self.collectionView.collectionViewLayout = flowLayout;
}
@end
