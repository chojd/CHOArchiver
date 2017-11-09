//
//  CHOArchiver.h
//  CHOArchiver
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * CHOArchivePathDomain;
FOUNDATION_EXTERN CHOArchivePathDomain const CHOArchivePathDomainForRoot;// archive root path
FOUNDATION_EXTERN CHOArchivePathDomain const CHOArchivePathDomainForDefault;
FOUNDATION_EXTERN CHOArchivePathDomain const CHOArchivePathDomainForSharedInstance;

@interface CHOArchiver : NSObject

@property (nonatomic, copy, readonly) NSString *rootPath;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedArchiver;

- (NSString *)rootFolderPath;

- (BOOL)saveObject:(id<NSCoding, NSObject>)object inPathDomain:(CHOArchivePathDomain)domain filename:(NSString *)filename;

- (nullable id<NSCoding, NSObject>)objectInPathDomain:(CHOArchivePathDomain)domain filename:(NSString *)filename;

- (BOOL)removeObjectInPathDomain:(CHOArchivePathDomain)domain filename:(NSString *)filename;


- (BOOL)saveObject:(id<NSCoding, NSObject>)object filename:(NSString *)filename;

- (nullable id<NSCoding, NSObject>)objectWithFilename:(NSString *)filename;
- (BOOL)removeObjectWithFilename:(NSString *)filename;


- (BOOL)saveSharedInstance:(id<NSCoding, NSObject>)instance;
- (nullable id<NSCoding, NSObject>)sharedInstanceForClass:(Class)aClass;
- (BOOL)removeSharedInstanceForClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
