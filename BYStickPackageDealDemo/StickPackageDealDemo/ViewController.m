//
//  ViewController.m
//  StickPackageDealDemo
//
//  Created by lby on 2017/1/16.
//  Copyright © 2017年 lby. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// 存储处理后的每次返回数据
@property (nonatomic, strong) NSMutableArray *mutArr;
// 数据缓冲池
@property (nonatomic, copy) NSString *tempData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 第一次测试 -- 完整型**/
    /* 
     第1次 : abcd
     第2次 : abcdabcd
     第3次 : abcdabcdabcd
     */
    // 数组中的数据代表每次接收的数据
    NSArray *testArr1 = [NSArray arrayWithObjects:@"abcd",@"abcdabcd",@"abcdabcdabcd", nil];
    self.tempData = @"";
    for (NSInteger i = 0; i < testArr1.count; i++)
    {
        [self dealStickPackageWithData:testArr1[i]];
    }
    NSLog(@"testArr1 = %@",self.mutArr);
    
    /** 第二次测试 -- 多余型**/
    self.mutArr = nil;
    /*
     第1次 : abcdab
     第2次 : cdabcda
     第3次 : bcdabcd
     */
    // 数组中的数据代表每次接收的数据
    NSArray *testArr2 = [NSArray arrayWithObjects:@"abcdab",@"cdabcda",@"bcdabcd", nil];
    self.tempData = @"";
    for (NSInteger i = 0; i < testArr2.count; i++)
    {
        [self dealStickPackageWithData:testArr2[i]];
    }
    NSLog(@"testArr2 = %@",self.mutArr);
    
    /** 第三次测试 -- 不完整型**/
    self.mutArr = nil;
    /* 
     第1次 : abc
     第2次 : da
     第3次 : b
     第4次 : cdabc
     第5次 : dab
     */
    // 数组中的数据代表每次接收的数据
    NSArray *testArr3 = [NSArray arrayWithObjects:@"abc",@"da",@"b",@"cdabc",@"dab", nil];
    self.tempData = @"";
    for (NSInteger i = 0; i < testArr3.count; i++)
    {
        [self dealStickPackageWithData:testArr3[i]];
    }
    NSLog(@"testArr3 = %@",self.mutArr);
    
    /** 第四次测试 -- 混合型**/
    self.mutArr = nil;
    /* 
     第1次 : abc
     第2次 : da
     第3次 : bcdabcd
     第4次 : abcdabcd
     第5次 : abcdabcdab
     */
    // 数组中的数据代表每次接收的数据
    NSArray *testArr4 = [NSArray arrayWithObjects:@"abc",@"da",@"bcdabcd",@"abcdabcd",@"abcdabcdab", nil];
    self.tempData = @"";
    for (NSInteger i = 0; i < testArr4.count; i++)
    {
        [self dealStickPackageWithData:testArr4[i]];
    }
    NSLog(@"testArr4 = %@",self.mutArr);
}

- (NSMutableArray *)mutArr
{
    if (_mutArr == nil)
    {
        _mutArr = [NSMutableArray array];
    }
    return _mutArr;
}

/**
 处理数据粘包
 
 @param readData 读取到的数据
 */
- (void)dealStickPackageWithData:(NSString *)readData
{
    // 缓冲池还需要存储的数据个数
    NSInteger tempCount;
    
    if (readData.length > 0)
    {
        // 还差tempLength个数填满缓冲池
        tempCount = 4 - self.tempData.length;
        if (readData.length <= tempCount)
        {
            self.tempData = [self.tempData stringByAppendingString:readData];
            
            if (self.tempData.length == 4)
            {
                [self.mutArr addObject:self.tempData];
                self.tempData = @"";
            }
        }
        else
        {
            // 下一次的数据个数比要填满缓冲池的数据个数多,一定能拼接成完整数据,剩余的继续
            self.tempData = [self.tempData stringByAppendingString:[readData substringToIndex:tempCount]];
            [self.mutArr addObject:self.tempData];
            self.tempData = @"";
            
            // 多余的再执行一次方法
            [self dealStickPackageWithData:[readData substringFromIndex:tempCount]];
        }
    }
}


@end
