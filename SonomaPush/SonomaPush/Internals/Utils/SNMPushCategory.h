/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SNMPushCategory : NSObject

@property(nonatomic) BOOL isEnabled;

/**
 *  Activate category for UIViewController
 */
+ (void)activateCategory;

@end

NS_ASSUME_NONNULL_END
