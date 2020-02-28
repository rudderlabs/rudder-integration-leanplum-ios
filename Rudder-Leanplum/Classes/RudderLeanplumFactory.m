//
//  RudderAdjustFactory.m
//  FBSnapshotTestCase
//
//  Created by Arnab Pal on 29/10/19.
//

#import "RudderLeanplumFactory.h"
#import "RudderLeanplumIntegration.h"
#import "RudderLogger.h"

@implementation RudderLeanplumFactory

static RudderLeanplumFactory *sharedInstance;

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nonnull NSString *)key {
    return @"Leanplum";
}

- (nonnull id<RudderIntegration>)initiate:(nonnull NSDictionary *)config client:(nonnull RudderClient *)client rudderConfig:(nonnull RudderConfig *)rudderConfig {
    [RudderLogger logDebug:@"Creating RudderIntegrationFactory"];
    return [[RudderLeanplumIntegration alloc] initWithConfig:config withAnalytics:client withRudderConfig:rudderConfig];
}

@end
