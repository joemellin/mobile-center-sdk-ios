/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "SonomaCore+Internal.h"
#import <Foundation/Foundation.h>

@interface SNMPushInstallationLog : SNMAbstractLog

@property(nonatomic) NSString *installationId;

@property(nonatomic) NSString *pushChannel;

@property(nonatomic) NSString *platform;

@property(nonatomic) NSArray<NSString *> *tags;

@end
