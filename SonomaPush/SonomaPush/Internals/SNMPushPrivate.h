/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "SNMPush.h"
#import "SNMFeatureInternal.h"
#import "SNMDeviceTracker.h"

@interface SNMPush () <SNMFeatureInternal>


@property(nonatomic) SNMDeviceTracker *deviceTracker;

@end
