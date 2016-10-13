/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "SNMFeatureAbstract.h"
#import <UIKit/UIKit.h>

/**
 *  Sonoma push feature.
 */
@interface SNMPush : SNMFeatureAbstract

/**
 *  Register with push service.
 *
 */
+ (void)registerPush;

+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

+ (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

@end
