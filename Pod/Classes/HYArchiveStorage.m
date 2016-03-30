//
//  HYArchiveStorage.m
//  HYCoreFramework
//
//  Created by knight on 16/3/29.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HYArchiveStorage.h"

@interface HYArchiveStorage ()
@property (nonatomic , copy) NSString *path;
@property (nonatomic , strong) NSMutableDictionary *kvs;
@end

typedef void(^complete_t)(NSMutableDictionary *) ;
static dispatch_queue_t storage_creation_queue (){
    static dispatch_queue_t HY_storage_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HY_storage_creation_queue = dispatch_queue_create("com.bj.58.HYcoreframework.storage.processing", DISPATCH_QUEUE_SERIAL);
    });
    return HY_storage_creation_queue;
}

@implementation HYArchiveStorage
- (instancetype)initWithPath:(NSString *)path {
    NSAssert(path && path.length > 0, @"please make sure path isn't nil or empty!");
    self= [super init];
    if (self) {
        _path = [path copy];
        WeakSelf(weakSelf)
        [self kvsFromPath:path completion:^(NSMutableDictionary * dic){
            StrongSelf(weakSelf)
            self.kvs = dic.mutableCopy;
        }];
    }
    return self;
}

- (BOOL)containsObjectForKey:(id<NSCopying>)key {
    __block BOOL hasContain = NO;
    WeakSelf(weakSlef)
    dispatch_sync(storage_creation_queue(), ^{
        StrongSelf(weakSlef)
        if (self.kvs[key]) {//kvs 会与disk的数据保持一致
            hasContain = YES;
        }
    });
    return hasContain;
}

- (void)setValue:(id<NSCoding>)value forKey:(id<NSCopying>)key {
    WeakSelf(weakSelf)
    dispatch_async(storage_creation_queue(), ^{
        StrongSelf(weakSelf)
        if (self.kvs) {
           id data = self.kvs[key];
            if (data != value) {
                self.kvs[key] = value;
                NSString * filePath = [self.path stringByAppendingPathComponent:[self HY_keyToString:key]];
                [NSKeyedArchiver archiveRootObject:value toFile:filePath];
            }
        }
    });
}

- (id)objectForKey:(id<NSCopying>)key {
    __block id data = nil;
    WeakSelf(weakself)
    dispatch_sync(storage_creation_queue(), ^{
        StrongSelf(weakself)
        data = self.kvs[key];
    });
    return data;
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    WeakSelf(weakself)
    dispatch_async(storage_creation_queue(), ^{
        StrongSelf(weakself)
        NSString * filePath = [self.path stringByAppendingPathComponent:[self HY_keyToString:key]];
        if ([self HY_removeItemAtPath:filePath]) {
            [self.kvs removeObjectForKey:key];
        }
    });
}

- (void)removeAllObjects {
    WeakSelf(weakself)
    dispatch_async(storage_creation_queue(), ^{
        StrongSelf(weakself)
        NSString * filePath = self.path;
        if ([self HY_removeItemAtPath:filePath]) {
            [self.kvs removeAllObjects];
        }
    });
}

#pragma mark - private methods
- (void)kvsFromPath:(NSString *)path completion:(complete_t)complete {
    dispatch_sync(storage_creation_queue(), ^{
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            NSError * error = nil;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(!error, @"create disk cache path failed!");
        }
        NSError * error;
        NSArray * contentsDir = [fileManager contentsOfDirectoryAtPath:path error:&error];
        if (error) {
            NSException * fileSystemException = [NSException exceptionWithName:@"file system exception" reason:@"file read failed!" userInfo:@{@"error":error}];
            [fileSystemException raise];
        }
        NSMutableDictionary * dic = @{}.mutableCopy;
        if (contentsDir) {
            for (NSString * name in contentsDir) {
                NSString * filePath = [path stringByAppendingPathComponent:name];
                NSData * data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
                if (data) {
                    dic[name] = data;
                }
            }
        }
        complete(dic);
    });
}

- (NSString *)HY_keyToString:(id<NSCopying>)key {
    if (!key) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@",key];
}

- (BOOL)HY_fileExistsAtPath:(NSString *)path {
      NSFileManager * fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

- (BOOL)HY_removeItemAtPath:(NSString *)path{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([self HY_fileExistsAtPath:path]) {
        NSError * error = nil;
       BOOL isRemoved = [fileManager removeItemAtPath:path error:&error];
        if (isRemoved && !error) {
            return YES;
        }else {
            return NO;
        }
    }
    return NO;
}
@end
