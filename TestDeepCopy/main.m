//
//  main.m
//  TestDeepCopy
//
//  Created by Linsw on 2017/7/23.
//  Copyright © 2017年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define TLog(_var) ({ NSString *name = @#_var; NSLog(@"%@: %@ -> %p value:%@  retainCount:%d", name, [_var class], _var, _var, (int)[_var retainCount]); })

@interface Ele:NSObject
    @property (strong,nonatomic) NSDate *date;
@end

@implementation Ele

- (instancetype)init
{
    self = [super init];
    if (self) {
        _date = [NSDate date];
    }
    return self;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        //从数组和String类的分析，得出以下结论：
        //使用mutableCopy会分配新的内存，返回一个指向新内存的指针（不论原对象是mutable还是immutable）（使用mutableCopy创建的指针，指向的内存对象是可变的，可以通过id指针强行修改。
        //使用copy，当原对象是mutable时才会分配新内存，返回指向新内存的指针，当原对象是immutable，仅仅会进行指针复制，指向原对象。（使用了copy 创建的指针，指针指向的内存对象是不可变的，通过id指针强行调用修改的方法，会抛出异常）
        //
        
        
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//        NSArray *array = [NSArray arrayWithObject:[NSString stringWithFormat:@"aa"]];
        //数组中的元素并不影响数组的类型。
        NSArray *array = [NSArray arrayWithObject:[[Ele alloc] init]];
        
        NSMutableArray *mutableArray = [array copy];
        NSMutableArray *mutableArrayMC = [array mutableCopy];
        NSArray *arrayC = [array copy];
        NSArray *arrayMC = [array mutableCopy];
        id arrayMCCopy = [arrayMC copy];
        
        
        NSLog(@"%d",[array isKindOfClass:[NSArray class]]);//1
        NSLog(@"%d",[arrayC isKindOfClass:[NSArray class]]);//1
        NSLog(@"%d",[arrayMC isKindOfClass:[NSMutableArray class]]);//1
        
        //虽然arrayMC是NSArray类的，但是他指向的是NSMutableArray的内存，因此通过id变量可以对这块内存区域插入新数组元素
        id pAMC = arrayMC;
        [pAMC addObject:[[Ele alloc] init]];
        NSLog(@"%d",[arrayMC count]);//2
        
        NSDate *date = arrayMC[0];
        
        Ele *ele = arrayMC[0];
        ele.date = [NSDate dateWithTimeIntervalSince1970:0];
        //NSAssert([[(Ele *)arrayMC[0] date] isEqualToDate:ele.date], @"改变num.date 同时改变了数组里元素自身的属性");
        
        NSMutableArray *marray = [NSMutableArray arrayWithArray:array];
        NSArray *marrayC = [marray copy];
        NSMutableArray *marray_C = [marray copy];
        NSArray *marrayMC = [marray mutableCopy];
        NSMutableArray *marrayMMC = [marray mutableCopy];
        
        // 对于数组来说，copy的结果最后都是返回NSArray的指针，当源数组是NSArray时，返回的指针指向源数组，当源数组是NSMutableArray时，返回的指针指向新的NSArray数组。
        //mutablecopy都是返回一个指向新内存的NSMutableArray指针
        
        NSString *strconst = @"10";
        NSNumber *number = [NSNumber numberWithInt:1234567890];
        //当使用123456789或更短的数字来初始化str的时候，str对应的类是__NSTaggedString，
        //当使用1234567890或更长的数来初始化str，str对应的类是__NSCFString
        NSString *str = [number stringValue];
        NSString *strCopy = [str copy];
        NSString *strMuCopy = [str mutableCopy];
        
        id strMuCopyID = strMuCopy;
        [strMuCopyID appendString:strMuCopy];
        
        NSMutableString *mstr = [NSMutableString stringWithString:[number stringValue]];
        NSMutableString *mstrCopy = [mstr copy];
        NSMutableString *mstrMuCopy = [mstr mutableCopy];
        TLog(mstr);

        [mstr appendString:mstrMuCopy];
//        [mstrCopy appendString:mstrMuCopy];
        TLog(strconst);
        TLog(str);
        TLog(strCopy);
        TLog(strMuCopy);
        
        
        TLog(mstr);
        TLog(mstrCopy);
        TLog(mstrMuCopy);
    }
}
