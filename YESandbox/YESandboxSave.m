//
//  YESanboxSave.m
//  YYEPublicUtils
//
//  Created by yongen on 2017/6/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YESandboxSave.h"

#define DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

@interface YESandboxSave ()


@end

static NSString *const str = @"content.txt";
static NSString *const array = @"array.plist";
static NSString *const dic = @"dic.plist";
static NSString *const data = @"data.jpg";

@implementation YESandboxSave

//SingletonM(SandboxSave);

+ (id)sharedSandboxSave {
    static YESandboxSave  * sandboxSave= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sandboxSave = [[self alloc]init];
    });
    return sandboxSave;
}


- (void)insertObject:(id)object withFileName:(NSString *)fileName{

    if ([object isKindOfClass:[NSString class]]) {
        [object writeToFile:[self judgeClass:object withFileName:fileName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else {
      [object writeToFile:[self judgeClass:object withFileName:fileName] atomically:YES];
    }
}


- (id)queryObject:(QueryObject)type withFileName:(NSString *)fileName{
 
    switch (type) {
        case QueryObjectStr :  {
            NSString *queryStr = [NSString stringWithContentsOfFile:[self judgeType:type withFileName:fileName] encoding:NSUTF8StringEncoding error:nil];
            return queryStr;
            break;
        }
        case QueryObjectArray: {
            NSArray *queryArr = [NSArray arrayWithContentsOfFile:[self judgeType:type withFileName:fileName]];
            return queryArr;
           break;
        }
        case QueryObjectDic: {
            NSDictionary *queryDic = [NSDictionary dictionaryWithContentsOfFile:[self judgeType:type withFileName:fileName]];
            return queryDic;
             break;
        }
        case QueryObjectData: {
            NSData *imgData = [NSData dataWithContentsOfFile:[self judgeType:type withFileName:fileName]];
            return imgData;
            break;
        }
        default:
            break;
    }
}

- (BOOL)clearCacheWithObject:(QueryObject)type withFileName:(NSString *)fileName{

    if([[NSFileManager defaultManager] fileExistsAtPath:[self judgeType:type withFileName:fileName]]){
    
     return [[NSFileManager defaultManager] removeItemAtPath:[self judgeType:type withFileName:fileName] error:nil];
    }
    return NO;
}

- (NSString *)getCacheSizeWithObject:(QueryObject)type withFileName:(NSString *)fileName {
    
    NSString *path = [self judgeType:type withFileName:fileName];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    BOOL isDirectory = NO;
    // 3. 判断文件是否存在
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    // 4. 以上判断目的是忽略不需要计算的文件
    if (!isExist || isDirectory || [filePath containsString:@".DS"]){
        // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
        //  continue;
    }
    
    // 5. 指定路径，获取这个路径的属性
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    /**
     attributesOfItemAtPath: 文件夹路径
     该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
     这里刚好是要文件属性
     */
    
    // 6. 获取每一个文件的大小
    NSInteger size = [dict[@"NSFileSize"] integerValue];
    
    // 7. 计算总大小
    totleSize = size;
    
    //8. 将文件夹大小转换为 M/KB/B
    return [self totleString:totleSize];
}


//=======================================================================
//========================*** Model存入沙盒路径下 ***======================
//=======================================================================

- (void)insertModelKeyedArchiver:(id)model withModelName:(NSString *)name {
    
    [NSKeyedArchiver archiveRootObject:model toFile:[self modelSavePath:name]];
}

//使用反归档类对已归档的文件做反归档操作
- (id)queryModelKeyedUnarchiverWithModelName:(NSString *)name {
    
    NSArray *resultArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self modelSavePath:name]];
    return resultArray;
}


//=======================================================================
//=============================*** 华丽的分割线 ***========================
//=======================================================================


+ (void)saveImageArray:(NSMutableArray *)array andArrayName:(NSString *)fileName {
    
    NSString *path = [DocumentPath stringByAppendingPathComponent:fileName];
    NSLog(@"path=======%@", path);
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]){//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    for (int i =0 ; i < array.count; i++) {
        
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",fileName, i]];  // 保存文件的名称
        
        [UIImagePNGRepresentation(array[i]) writeToFile:filePath atomically:YES];
    }
}

+ (NSMutableArray *)getImageArrayWithName:(NSString *)fileName {
    
    NSMutableArray * imageArray = [NSMutableArray array];
    
    NSString *path = [DocumentPath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]){//判断createPath路径文件夹是否已存在，不存在直接返回
        
        return imageArray;
    }
    
    //此文件夹下所有图片名称
    NSArray *filesNameArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    
    if (filesNameArray && filesNameArray.count !=0 ) {
        
        for (int i =0 ; i < filesNameArray.count; i++) {
            
            UIImage * image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:filesNameArray[i]]];
            
            [imageArray addObject:image];
        }
    }
    return imageArray;
}


+ (BOOL)deleteImageName:(NSString * )imageName withFileName:(NSString *)fileName {
    
    
    NSString *path = [DocumentPath stringByAppendingPathComponent:fileName];
    
    NSString * pathFull = [path stringByAppendingPathComponent:imageName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pathFull]){
        
        return [[NSFileManager defaultManager] removeItemAtPath:pathFull error:nil];
        
    }
    return NO;
}

//清除fileName路径下(./fileName/xxx)所有的子文件夹的缓存(文件夹还在)
+ (BOOL)clearCacheWithFileNameSubfile:(NSString *)fileName {
    
    NSString *path = [DocumentPath stringByAppendingPathComponent:fileName];
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}

//清除fileName路径下(./fileName)整个文件夹的缓存(整个文件夹都没了)
+ (BOOL)clearCacheWithFileName:(NSString *)fileName {
    
    NSString *path = [DocumentPath stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
          [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
         return YES;
    }else {
      return NO;
    }
}

+ (NSString *)getCacheSizeWithFileName:(NSString *)fileName{
    
    NSString *path = [DocumentPath stringByAppendingPathComponent:fileName];
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    
    return totleStr;
}


//=======================================================================
//=============================*** 华丽的分割线 ***========================
//=======================================================================

#pragma mark - private

- (NSString *)modelSavePath:(NSString *)name {
    
    NSString *modelName = [NSString stringWithFormat:@"%@.plist", name];
    NSString *modelPath = [DocumentPath stringByAppendingPathComponent:modelName];
    NSLog(@"======modelPath==%@", modelPath);
    return modelPath;
}


- (NSString *)judgeType:(QueryObject)type withFileName:(NSString *)fileName{
    // [[object class] isSubclassOfClass:[NSDictionary class]];
    NSString *objectPath;
    switch (type) {
        case QueryObjectStr :  {
        NSString *objectSuffix = [NSString stringWithFormat:@"%@%@", fileName, str];
        objectPath = [DocumentPath stringByAppendingPathComponent:objectSuffix];
            break;
        }
        case QueryObjectArray: {
              NSString *objectSuffix = [NSString stringWithFormat:@"%@%@", fileName, array];
              objectPath = [DocumentPath stringByAppendingPathComponent:objectSuffix];
            break;
        }
        case QueryObjectDic: {
              NSString *objectSuffix = [NSString stringWithFormat:@"%@%@", fileName, dic];
           objectPath = [DocumentPath stringByAppendingPathComponent:objectSuffix];
            break;
        }
        case QueryObjectData: {
            NSString *objectSuffix = [NSString stringWithFormat:@"%@%@", fileName, data];
           objectPath = [DocumentPath stringByAppendingPathComponent:objectSuffix];
            break;
        }
    }
    return objectPath;
}


- (NSString *)judgeClass:(id)object withFileName:(NSString *)fileName {
    // [[object class] isSubclassOfClass:[NSDictionary class]];
    NSString *objectPath;
 
    if ([object isKindOfClass:[NSDictionary class]] ) {
        NSString *objectSuffix = [NSString stringWithFormat:@"%@%@", fileName, dic];
        objectPath = [DocumentPath stringByAppendingPathComponent:objectSuffix];
        NSLog(@"===========NSDictionary===========");
    }
    if ([object isKindOfClass:[NSArray class]]) {
              NSString *objectSuffix = [NSString stringWithFormat:@"%@%@", fileName, array];
        objectPath = [DocumentPath stringByAppendingPathComponent:objectSuffix];
        NSLog(@"===========NSArray===========");
    }
    if ([object isKindOfClass:[NSString class]]) {
              NSString *objectSuffix = [NSString stringWithFormat:@"%@%@", fileName, str];
        objectPath = [DocumentPath stringByAppendingPathComponent:objectSuffix];
        NSLog(@"===========NSString===========");
        
    }
    if ([object isKindOfClass:[NSData class]]) {
              NSString *objectSuffix = [NSString stringWithFormat:@"%@%@", fileName, data];
        objectPath = [DocumentPath stringByAppendingPathComponent:objectSuffix];
        NSLog(@"===========NSData===========");
    }
    NSLog(@"======objectPath==%@", objectPath);
    return objectPath;
}

//单位换算---将文件夹大小转换为 M/KB/B
- (NSString *)totleString:(NSInteger)totleSize {
    
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}

@end
