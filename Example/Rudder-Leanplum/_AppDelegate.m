//
//  _AppDelegate.m
//  Rudder-Leanplum
//
//  Created by arnabp92 on 02/27/2020.
//  Copyright (c) 2020 arnabp92. All rights reserved.
//

#import "_AppDelegate.h"
#import <Rudder/Rudder.h>
#import "RudderLeanplumFactory.h"

static NSString *DATA_PLANE_URL = @"https://1067ea42.ngrok.io";
static NSString *CONTROL_PLANE_URL = @"https://1067ea42.ngrok.io";
static NSString *WRITE_KEY = @"1Zag1Le2RcAMFzJBJjSIyqfKJyL";

@implementation _AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
    [builder withDataPlaneUrl:DATA_PLANE_URL];
    [builder withControlPlaneUrl:CONTROL_PLANE_URL];
    [builder withFactory:[RudderLeanplumFactory instance]];
    [builder withLoglevel:RSLogLevelDebug];
    [RSClient getInstance:WRITE_KEY config:[builder build]];
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
