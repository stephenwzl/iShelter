//
//  WZLDataUtils.m
//  iShelter
//
//  Created by wangzhilong on 15/7/22.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "WZLDataUtils.h"
#import "FMDB.h"
@interface WZLDataUtils()
@property (strong, nonatomic)FMDatabase *db;
@end

@implementation WZLDataUtils

+ (instancetype)sharedDataUtils {
    static WZLDataUtils *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[WZLDataUtils alloc] init];
    });
    return model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.db open];
        NSString *sql = @"create table books (id integer primary key autoincrement, name text,font integer,page integer,lastread text);CREATE TABLE bookMark (id integer,name text(128),page integer(128) NOT NULL,PRIMARY KEY(id, page)CONSTRAINT 'notchongfu' UNIQUE (name,page) ON CONFLICT REPLACE);CREATE TABLE reserved (id integer PRIMARY KEY AUTOINCREMENT NOT NULL,name text(128),content text(128));";
        BOOL success = [self.db executeStatements:sql];
        if (success) {
            [self copyToSandBox];
        }
        
        [self.db close];
    }
    return self;
}

- (BOOL)insertBooks:(NSArray *)books {
    return [self.db open];
}

- (NSDictionary *)getBookByName:(NSString *)bookName {
    NSArray *allBooks = [self getAllBooks];
    for (NSDictionary * dic in allBooks) {
        if ([dic[@"name"] isEqualToString:bookName]) {
            return dic;
        }
    }
    return nil;
}

- (NSMutableArray *)getAllBooks {
    NSMutableArray *outcome = [[NSMutableArray alloc] init];
    [self.db open];
    FMResultSet *result = [self.db executeQuery:@"select * from books order by lastread desc"];
    while ([result next]) {
        NSString *bookName = [result stringForColumn:@"name"];
        NSNumber *font = [NSNumber numberWithInt:[result intForColumn:@"font"]];
        NSNumber *page = [NSNumber numberWithInt:[result intForColumn:@"page"]];
        NSString *lastRead = [result stringForColumn:@"lastread"];
        NSDictionary *book = @{@"name":bookName,@"font":font,@"page":page,@"lastread":lastRead};
        [outcome addObject:book];
    }
    [self.db close];
    return outcome;
}

- (void)updateBook:(NSDictionary *)book {
    [self.db open];
    NSString *lastread = book[@"lastread"];
    NSNumber *font = book[@"font"];
    NSNumber *page = book[@"page"];
    NSString *name = book[@"name"];
    NSString *sql = [NSString stringWithFormat:@"update books set lastread= '%@',font = %d, page = %d where name='%@'",lastread,font.intValue,page.intValue,name];
    [self.db executeStatements:sql];
    [self.db close];
}

- (void)copyToSandBox {
    NSString *doc1 = [[NSBundle mainBundle] pathForResource:@"左耳" ofType:@"txt"];
    NSString *doc2 = [[NSBundle mainBundle] pathForResource:@"沙漏" ofType:@"txt"];
    NSString *doc3 = [[NSBundle mainBundle] pathForResource:@"十年" ofType:@"txt"];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager copyItemAtPath:doc1 toPath:[docPath stringByAppendingPathComponent:[doc1 lastPathComponent]]error:nil];
    [manager copyItemAtPath:doc2 toPath:[docPath stringByAppendingPathComponent:[doc2 lastPathComponent]] error:nil];
    [manager copyItemAtPath:doc3 toPath:[docPath stringByAppendingPathComponent:[doc3 lastPathComponent]] error:nil];
    [self.db open];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    NSString *sql = [NSString stringWithFormat:@"insert into books (name,font,page,lastread) values ('左耳',17,0,'%@');insert into books (name,font,page,lastread) values ('沙漏',17,0,'%@');insert into books (name,font,page,lastread) values ('十年',17,0,'%@');",destDateString,destDateString,destDateString];
    BOOL success = [self.db executeStatements:sql];
    if (success) {
        NSLog(@"初始化成功");
    }
    [self.db close];
}

- (NSString *)dbDirectory {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",docPath);
    return [docPath stringByAppendingPathComponent:@"book.sqlite"];
}

- (NSMutableArray *)getAllBookMark {
    NSMutableArray *outcome = [[NSMutableArray alloc] init];
    [self.db open];
    FMResultSet *set = [self.db executeQuery:@"select * from bookMark"];
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        NSNumber *page = [NSNumber numberWithInt:[set intForColumn:@"page"]];
        NSDictionary *dic = @{@"name":name,@"page":page};
        [outcome addObject:dic];
    }
    [self.db close];
    return outcome;
}

- (NSMutableArray *)getBookMarkByName:(NSString *)bookName {
    NSMutableArray *array = [self getAllBookMark];
    NSMutableArray *outcome = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        if ([dic[@"name"] isEqualToString:bookName]) {
            [outcome addObject:dic];
        }
    }
    return outcome;
}

- (void)insertBookMark:(NSDictionary *)dic {
    [self.db open];
    
    NSString *name = dic[@"name"];
    NSNumber *page = dic[@"page"];
    NSString *sql = [NSString stringWithFormat:@"insert into bookMark (name,page) values ('%@',%d)",name,page.intValue];
    BOOL success = [self.db executeStatements:sql];
    if (success) {
        NSLog(@"插入完成");
    }else {
        NSLog(@"插入失败");
    }
    [self.db close];
}

- (void)insertReserves:(NSDictionary *)dic {
    [self.db open];
    NSString *sql = [NSString stringWithFormat:@"insert into reserved (name,content) values ('%@','%@')",dic[@"name"],dic[@"content"]];
    BOOL success =  [self.db executeStatements:sql];
    if (success) {
        NSLog(@"插入完成");
    }else {
        NSLog(@"插入失败");
    }
    [self.db close];
}

- (NSMutableArray *)getAllReserves {
    NSMutableArray *outcome = [[NSMutableArray alloc] init];
    [self.db open];
    FMResultSet *set = [self.db executeQuery:@"select * from reserved order by id desc"];
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        NSString *content = [set stringForColumn:@"content"];
        NSDictionary *dic = @{@"name":name,@"content":content};
        [outcome addObject:dic];
    }
    
    [self.db close];
    return outcome;
}

#pragma mark lazyload
- (FMDatabase *)db {
    if (!_db) {
        _db = [FMDatabase databaseWithPath:[self dbDirectory]];
    }
    return _db;
}
@end
