//
//  ViewController.m
//  FMDB
//
//  Created by summerxx on 16/10/12.
//  Copyright © 2016年 summerxx. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
@interface ViewController ()
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSTimer *time;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*-------------数据存储操作---------------*/
    // 数据库路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"StaffPosition.db"];
    NSLog(@"数据库路径 ======= %@", dbPath);
    _db = [FMDatabase databaseWithPath:dbPath];
    [_db beginTransaction];
    
    // 左按钮测试
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 60, 40);
    [btnLeft setTitle:@"T_T" forState:UIControlStateNormal];
    btnLeft.backgroundColor = [UIColor blackColor];
    [btnLeft addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    if ([_db open]) {
        // 创建表
        [_db executeUpdate:@"create table weibo (created_at text, text text, current text)"];
    }
    _time = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        //
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 定义时间为这种格式： YYYY-MM-dd hh:mm:ss
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        // 将NSDate  ＊对象 转化为 NSString ＊对象
        NSString *current = [formatter stringFromDate:[NSDate date]];
        NSLog(@"当前的时间 === %@", current);
        if ([_db open]) {
            // 插入数据
            [_db executeUpdate:@"insert into weibo (created_at, text, current) values (?, ?, ?)"
             ,@"夏天", @"iOS开发者, 爱分享, 爱学习", current];
        }
        NSLog(@"------------------");
    }];
    [_time fire];
}
- (void)btnClick:(UIButton *)btn
{
    [_time invalidate];
    
        //
        if ([_db open]) {
            NSString *sql = @"select * from weibo";
            FMResultSet *rs = [_db executeQuery:sql];
            while ([rs next]) {
                // 把相应的数据打印出来
                NSLog(@"created_at = %@, text = %@, current = %@", [rs objectForColumnName:@"created_at"], [rs objectForColumnName:@"text"], [rs objectForColumnName:@"current"]);
            }
        }
    if ([_db open]) {
        NSString *updateSql = [NSString stringWithFormat:@"update weibo set current = '%@' where created_at = '%@'", @"XXXXXXXXX", @"夏天"];
        BOOL res = [_db executeUpdate:updateSql];
        if (!res) {
            NSLog(@"更新失败");
        }else{
            NSLog(@"更新成功");
        }
        [_db close];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
