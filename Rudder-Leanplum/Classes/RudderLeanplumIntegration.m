//
//  RudderAdjustIntegration.m
//  FBSnapshotTestCase
//
//  Created by Arnab Pal on 29/10/19.
//

#import "RudderLeanplumIntegration.h"
#import "RudderLogger.h"
#import <Leanplum/Leanplum.h>

@implementation RudderLeanplumIntegration

#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RudderClient *)client  withRudderConfig:(nonnull RudderConfig *)rudderConfig {
    self = [super init];
    if (self) {
        NSString *appId = config[@"applicationId"];
        NSString *clientKey = config[@"clientKey"];
        BOOL isDevelop = config[@"isDevelop"];
        
        if (appId != nil && clientKey != nil) {
            if (isDevelop) {
                [Leanplum setAppId:appId withDevelopmentKey:clientKey];
            } else {
                [Leanplum setAppId:appId withProductionKey:clientKey];
            }
            
            if (rudderConfig.logLevel >= RudderLogLevelDebug) {
                [Leanplum setVerboseLoggingInDevelopmentMode:YES];
            } else {
                [Leanplum setVerboseLoggingInDevelopmentMode:NO];
            }
            
            NSMutableDictionary *traits = [client getContext].traits;
            NSString *userId = traits[@"userId"];
            if (userId != nil) {
                [Leanplum startWithUserId:userId];
            } else {
                [Leanplum start];
            }
        }
        
    }
    [RudderLogger logDebug:@"Initializing Leanplum SDK"];
    return self;
}

- (void) dump:(RudderMessage *)message {
    if (message != nil) {
        [self processRudderEvent:message];
    }
}

- (void) processRudderEvent: (nonnull RudderMessage *) message {
    NSString *type = message.type;
    if ([type isEqualToString:@"identify"]) {
        [Leanplum setUserId:message.userId withUserAttributes:message.context.traits];
    } else if ([type isEqualToString:@"track"] || [type isEqualToString:@"screen"]) {
        if (message.event != nil) {
            [Leanplum track:message.event withParameters:message.properties];
        }
    }
}

- (void) reset {
    [Leanplum clearUserContent];
}

@end

