//
//  HYAppDelegate.m
//  HYStorage
//
//  Created by knight on 03/30/2016.
//  Copyright (c) 2016 knight. All rights reserved.
//

#import "HYAppDelegate.h"
#import "HYArchiveStorage.h"
@interface HYAppDelegate ()
@property (nonatomic ,strong) HYArchiveStorage * storage;
@end

@implementation HYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString * filePath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * fileName = [filePath stringByAppendingPathComponent:@"storageTest"];
    NSLog(@"fileName = %@",fileName);
    self.storage = [[HYArchiveStorage alloc]  initWithPath:fileName];
    for (int i = 0; i< 10; i++) {
        
        NSString * key = [NSString stringWithFormat:@"key%d",i];
        //归档时解开注释
//        NSString * value = @"hahahahahaha";
//        [self.storage setValue:value forKey:key];
        
        //取数据
        id value = [self.storage objectForKey:key];
        NSLog(@"key = %@ | value = %@",key,value);
        
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
