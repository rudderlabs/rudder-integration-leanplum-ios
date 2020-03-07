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
            if (userId == nil) {
                userId = traits[@"id"];
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                if (userId != nil) {
                    [Leanplum startWithUserId:userId];
                } else {
                    [Leanplum start];
                }
            });
        }
        
    }
    [RudderLogger logDebug:@"Initializing Leanplum SDK"];
    return self;
}

- (void) dump:(RudderMessage *)message {
    @try {
        if (message != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
              [self processRudderEvent:message];
            });
        }
    } @catch (NSException *ex) {
        [RudderLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (void) processRudderEvent: (nonnull RudderMessage *) message {
    NSString *type = message.type;
    if ([type isEqualToString:@"identify"]) {
        [Leanplum setUserId:message.userId withUserAttributes:message.context.traits];
    } else if ([type isEqualToString:@"track"]) {
        if (message.event != nil) {
            NSDictionary *properties = message.properties;
            properties = [self filterProperties:properties];
            if (properties != nil) {
                id value = [properties objectForKey:@"value"];
                if (value != nil) {
                    if ([value isKindOfClass:[NSNumber class]]) {
                        double val = [value doubleValue];
                        [Leanplum track:message.event withValue:val andParameters:properties];
                    } else {
                        [Leanplum track:message.event withParameters:properties];
                    }
                } else {
                    [Leanplum track:message.event withParameters:properties];
                }
            } else {
                [Leanplum track:message.event];
            }
        }
    } else if ([type isEqualToString:@"screen"]) {
        if (message.event != nil) {
            [Leanplum advanceTo:message.event withParameters:message.properties];
        }
    }
}

- (NSDictionary*) filterProperties: (NSDictionary*) properties {
    if (properties != nil) {
        NSMutableDictionary *filteredProperties = [[NSMutableDictionary alloc] init];
        for (NSString *key in properties.allKeys) {
            id val = properties[key];
            if ([val isKindOfClass:[NSString class]] || [val isKindOfClass:[NSNumber class]]) {
                filteredProperties[key] = val;
            }
        }
        return filteredProperties;
    } else {
        return nil;
    }
}

- (void) reset {
    [Leanplum clearUserContent];
}

@end

