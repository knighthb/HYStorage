//
//  HBStorage.m
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HYStorage.h"

@implementation HYStorage
- (void)setValue:(id)value forKey:(id<NSCopying>)key {
    [self doesNotRecognizeSelector:_cmd];
}

- (id)objectForKey:(id<NSCopying>)key {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)removeAllObjects {
    [self doesNotRecognizeSelector:_cmd];
}

- (BOOL)containsObjectForKey:(id<NSCopying>)key {
    NSAssert(key, @"key must'nt be nil!");
    if ([self objectForKey:key]) {
        return YES;
    }else{
        return NO;
    }
}
@end
