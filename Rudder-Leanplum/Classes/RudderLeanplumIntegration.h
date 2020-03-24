//
//  RudderAdjustIntegration.h
//  FBSnapshotTestCase
//
//  Created by Arnab Pal on 29/10/19.
//

#import <Foundation/Foundation.h>
#import "RudderIntegration.h"
#import "RudderClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface RudderLeanplumIntegration : NSObject<RudderIntegration>

@property (nonatomic) BOOL sendEvents;

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RudderClient *)client withRudderConfig:(RudderConfig*) rudderConfig;

@end

NS_ASSUME_NONNULL_END
