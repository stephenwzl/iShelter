//
//  CollectionViewController.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//



#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "WZLDataUtils.h"
static NSString *kOpenBookName = @"openBookName";
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
        _bookFiles = [[WZLDataUtils sharedDataUtils] getAllBooks];
    }
    return _bookFiles;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSNumber *index = sender;
    [[NSUserDefaults standardUserDefaults] setObject:self.bookFiles[index.integerValue][@"name"] forKey:@"bookName"];
    [[NSNotificationCenter defaultCenter]postNotificationName:kOpenBookName object:self.bookFiles[index.integerValue][@"name"] ];
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
    cell.bookTitle.text = self.bookFiles[indexPath.item][@"name"];
    NSString *recentReadName = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentRead"];
    if ([cell.bookTitle.text isEqualToString: recentReadName]) {
        cell.coverImg.image = [UIImage imageNamed:@"bookCoverRecent"];
    }else {
        cell.coverImg.image = [UIImage imageNamed:@"bookCover"];
    }
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

#pragma mark Segue
- (IBAction)backToShelter:(UIStoryboardSegue *)sender {
    self.bookFiles = [[WZLDataUtils sharedDataUtils] getAllBooks];
    [self.collectionView reloadData];
}
@end
