//
//  YESanboxSave.h
//  YYEPublicUtils
//
//  Created by yongen on 2017/6/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QueryObject){
    QueryObjectStr,       // 字符串
    QueryObjectArray,     // 数组
    QueryObjectDic,       // 字典
    QueryObjectData        //  NSData (图片二进制流)
};


@interface YESandboxSave : NSObject

// SingletonH(SandboxSave);

+ (id)sharedSandboxSave;


//=======================================================================
//==========*** 单个对象(array, dic, str, img)存入沙盒路径下 ***=============
//=======================================================================
/**
 二进制（图片）对象写入文件，这里直接传入NSData类型(😂😂😂😂这句话很重要😂😂😂😂)
 
 NSData *data = UIImageJPEGRepresentation(<#UIImage *image#>, 0.9);
 NSData *data = UIImagePNGRepresentation(<#UIImage *image#>)

 */

- (void)insertObject:(id)object withFileName:(NSString *)fileName;

/*!
 * @abstract 查询一个对象
 *
 * @param type 查询对象类型
 * @param fileName 文件名
 */
- (id)queryObject:(QueryObject)type withFileName:(NSString *)fileName;

/*!
 * @abstract 删除一个对象
 *
 * @param type 删除对象类型
 * @param fileName 文件名
 */

- (BOOL)clearCacheWithObject:(QueryObject)type withFileName:(NSString *)fileName;

/*!
 * @abstract 查询一个对象大小(不是文件夹)(因为查询路径原因，下面又单独写查询文件夹方法)
 *
 * @param type 删除对象类型
 * @param fileName 文件名
 */
- (NSString *)getCacheSizeWithObject:(QueryObject)type withFileName:(NSString *)fileName;

//=======================================================================
//========================*** Model存入沙盒路径下 ***======================
//=======================================================================

/*
 * @abstract 注意： 这里的很重要(😂😂😂😂)
 *
 * 一个自定义类的对象要进行持久化操作，需要对应类的对象遵守NSCoding协议并实现编码和解码协议方法
 * 建议使用MJExtension
 * 在你要保存的model的（.m文件）中直接调用这个宏(MJCodingImplementation)就完事了
 */


/*!
 * @abstract model沙盒存储
 *
 * @param model 存储对象
 * @param name 存储对象name
 *
 */

- (void)insertModelKeyedArchiver:(id)model withModelName:(NSString *)name;
- (id)queryModelKeyedUnarchiverWithModelName:(NSString *)name;


/**
 *  将图片数组以arrayName存储
 *
 *  @param array     图片数组，数组元素是UIImage
 *  @param fileName 存储图片文件名称
 */
+(void)saveImageArray:(NSMutableArray *)array andArrayName:(NSString *)fileName;

/**
 *  获取arrayName文件夹下所有图片
 *
 *  @param fileName 文件名称
 *
 *  @return 返回元素UIImage组成的数组
 */
+(NSMutableArray *)getImageArrayWithName:(NSString *)fileName;

/**
 *  删除fileName文件夹下名称为imageName的文件
 *
 *  @param imageName image名称
 *  @param fileName  文件夹名称
 *
 *  @return 是否删除成功
 */
+(BOOL)deleteImageName:(NSString * )imageName withFileName:(NSString *)fileName;


/**
 *  清除fileName路径下(./fileName/xxx)所有的子文件夹的缓存(文件夹还在)
 *
 *  @param fileName 文件夹name
 *
 *  @return 是否清除成功
 */

+ (BOOL)clearCacheWithFileNameSubfile:(NSString *)fileName;

/**
 *  清除fileName路径下(./fileName)整个文件夹的缓存(整个文件夹都没了)
 *
 *  @param fileName 文件夹name
 *
 *  @return 是否清除成功
 */
+ (BOOL)clearCacheWithFileName:(NSString *)fileName;


/**
 *  获取path路径下文件夹的大小
 *
 *  @param fileName 文件夹name
 *
 *  @return 返回path路径下文件夹的大小
 */
+ (NSString *)getCacheSizeWithFileName:(NSString *)fileName;



@end
