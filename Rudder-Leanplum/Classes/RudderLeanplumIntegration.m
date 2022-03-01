//
//  RudderAdjustIntegration.m
//  FBSnapshotTestCase
//
//  Created by Arnab Pal on 29/10/19.
//

#import "RudderLeanplumIntegration.h"
#import <Leanplum/Leanplum.h>

@implementation RudderLeanplumIntegration

#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RSClient *)client  withRudderConfig:(nonnull RSConfig *)rudderConfig {
    self = [super init];
    if (self) {
        NSString *appId = config[@"applicationId"];
        NSString *clientKey = config[@"clientKey"];
        BOOL isDevelop = [[config objectForKey:@"isDevelop"] boolValue];
        self.sendEvents = [[config objectForKey:@"useNativeSDKToSend"] boolValue];
        
        if (appId != nil && clientKey != nil) {
            if (isDevelop) {
                [Leanplum setAppId:appId withDevelopmentKey:clientKey];
            } else {
                [Leanplum setAppId:appId withProductionKey:clientKey];
            }
            
            [self setLogLevel : [rudderConfig logLevel]];
            
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
    [RSLogger logDebug:@"Initializing Leanplum SDK"];
    return self;
}

- (void) dump:(RSMessage *)message {
    @try {
        if (self.sendEvents && message != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
              [self processRudderEvent:message];
            });
        }
    } @catch (NSException *ex) {
        [RSLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString *type = message.type;
    if ([type isEqualToString:@"identify"]) {
        [Leanplum setUserId:message.userId withUserAttributes:message.context.traits];
    } else if ([type isEqualToString:@"track"]) {
        if (message.event != nil) {
            NSDictionary *properties = message.properties;
            properties = [self filterProperties:properties];
            if ([message.event isEqualToString:@"Order Completed"]) {
                if (properties != nil) {
                    id currency = [properties objectForKey:@"currency"];
                    id revenue = [properties objectForKey:@"revenue"];
                    if (revenue != nil && [revenue isKindOfClass:[NSNumber class]]) {
                        [Leanplum trackPurchase:message.event
                                      withValue:[revenue doubleValue]
                                andCurrencyCode:currency andParameters:properties];
                    } else {
                        [Leanplum track:message.event
                         withParameters:properties];
                    }
                } else {
                    [Leanplum track:message.event];
                }
            }
            if (properties != nil) {
                id value = [properties objectForKey:@"value"];
                if (value != nil) {
                    if ([value isKindOfClass:[NSNumber class]]) {
                        double val = [value doubleValue];
                        [Leanplum track:message.event
                              withValue:val
                          andParameters:properties];
                    } else {
                        [Leanplum track:message.event
                         withParameters:properties];
                    }
                } else {
                    [Leanplum track:message.event
                     withParameters:properties];
                }
            } else {
                [Leanplum track:message.event];
            }
        }
    } else if ([type isEqualToString:@"screen"]) {
        if (message.event != nil) {
            [Leanplum advanceTo:message.event
                 withParameters:message.properties];
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

- (void)flush {
    
}

#pragma mark - Utils

-(void) setLogLevel:(int) rsLogLevel {
    if (rsLogLevel >= RSLogLevelDebug)
    {
        [Leanplum setLogLevel:LPLogLevelDebug];
        return;
    }
    if (rsLogLevel == RSLogLevelInfo)
    {
        [Leanplum setLogLevel:LPLogLevelInfo];
        return;
    }
    if (rsLogLevel >= RSLogLevelError)
    {
        [Leanplum setLogLevel:LPLogLevelError];
        return;
    }
    [Leanplum setLogLevel:LPLogLevelOff];
}

@end

