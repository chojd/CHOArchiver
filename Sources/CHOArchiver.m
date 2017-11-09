//
//  CHOArchiver.m
//  CHOArchiver
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//


#import "CHOArchiver.h"

CHOArchivePathDomain const CHOArchivePathDomainForRoot = @"com_chojd_archive";
CHOArchivePathDomain const CHOArchivePathDomainForDefault = @"default";
CHOArchivePathDomain const CHOArchivePathDomainForSharedInstance = @"shared_instance";

@implementation CHOArchiver

+ (instancetype)sharedArchiver {
    static CHOArchiver *_shareArchiver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareArchiver = [[self alloc] init];
    });
    return _shareArchiver;
}

- (NSString *)rootFolderPath {
    NSString *libDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *rootPath = [libDirectory stringByAppendingPathComponent:CHOArchivePathDomainForRoot];
    [self findOrCreateFolderPath:rootPath];
    return rootPath;
}

- (BOOL)saveObject:(id<NSCoding, NSObject>)object inPathDomain:(CHOArchivePathDomain)domain filename:(NSString *)filename {
    if (!object || !filename) {
        return NO;
    }
    
    NSString *path = [self filePathInDomain:domain filename:filename];
    BOOL result =  [NSKeyedArchiver archiveRootObject:object toFile:path];
    return result;
}

- (id<NSCoding, NSObject>)objectInPathDomain:(CHOArchivePathDomain)domain filename:(NSString *)filename {
    if (!filename) {
        return nil;
    }
    
    NSString *path = [self filePathInDomain:domain filename:filename];
    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return object;
}

- (BOOL)removeObjectInPathDomain:(CHOArchivePathDomain)domain filename:(NSString *)filename {
    NSString *path = [self filePathInDomain:domain filename:filename];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileMgr removeItemAtPath:path error:&error];
    NSAssert(result == YES, error.description);
    return result;
}

- (BOOL)saveObject:(id<NSCoding, NSObject>)object filename:(NSString *)filename {
    BOOL result = [self saveObject:object inPathDomain:CHOArchivePathDomainForDefault filename:filename];
    return result;
}

- (id<NSCoding, NSObject>)objectWithFilename:(NSString *)filename {
    id object = [self objectInPathDomain:CHOArchivePathDomainForDefault filename:filename];
    return object;
}

- (BOOL)removeObjectWithFilename:(NSString *)filename {
    return [self removeObjectInPathDomain:CHOArchivePathDomainForDefault filename:filename];
}

- (BOOL)saveSharedInstance:(id<NSCoding, NSObject>)instance {
    BOOL result = [self saveObject:instance inPathDomain:CHOArchivePathDomainForSharedInstance filename:[self hashStringForClass:[instance class]]];
    return result;
}

- (id<NSCoding, NSObject>)sharedInstanceForClass:(Class)aClass {
    id <NSCoding, NSObject>object = [self objectInPathDomain:CHOArchivePathDomainForSharedInstance filename:[self hashStringForClass:aClass]];
    return object;
}

- (BOOL)removeSharedInstanceForClass:(Class)aClass {
    return [self removeObjectInPathDomain:CHOArchivePathDomainForSharedInstance filename:[self hashStringForClass:aClass]];
}

#pragma mark - Private method

- (NSString *)filePathInDomain:(CHOArchivePathDomain)domain filename:(NSString *)filename {
    
    NSString *domainPath = [[self rootFolderPath] stringByAppendingPathComponent:domain];
    [self findOrCreateFolderPath:domainPath];
    
    NSString *fullPath = [domainPath stringByAppendingPathComponent:filename];
    return fullPath;
}

- (BOOL)findOrCreateFolderPath:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:folderPath]) {
        BOOL result =  [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSAssert(result == YES, @"file creation error");
        return result;
    }
    
    return YES;
}

- (NSString *)hashStringForClass:(Class)theClass {
    return [@([NSStringFromClass(theClass) hash]) stringValue];
}

@end
