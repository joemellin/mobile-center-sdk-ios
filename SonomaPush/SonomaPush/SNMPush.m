/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "SNMPush.h"
#import "SNMPushCategory.h"
#import "SNMPushPrivate.h"
#import "SNMFeatureAbstractProtected.h"
#import "SNMSonoma.h"
#import "SNMSonomaInternal.h"
#import "SonomaCore+Internal.h"
#import "SNMPushInstallationLog.h"

@import UserNotifications;


/**
 *  Feature storage key name.
 */
static NSString *const kSNMFeatureName = @"Push";

@implementation SNMPush


#pragma mark - Module initialization

- (instancetype)init {
  if (self = [super init]) {
    
    _deviceTracker = [[SNMDeviceTracker alloc] init];
  }
  return self;
}

#pragma mark - SNMFeatureInternal

+ (instancetype)sharedInstance {
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)startFeature {
  [super startFeature];

  SNMLogVerbose(@"SNMPush: Started push module");
}

- (NSString *)storageKey {
  return kSNMFeatureName;
}

- (SNMPriority)priority {
  return SNMPriorityDefault;
}

#pragma mark - SNMFeatureAbstract

- (void)setEnabled:(BOOL)isEnabled {
  [super setEnabled:isEnabled];
}

#pragma mark - Module methods

+ (void)registerPush {
  [[self sharedInstance] registerPush];
}

+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[self sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

+ (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error; {
  [[self sharedInstance] didFailToRegisterForRemoteNotificationsWithError:error];
}


#pragma mark - Private methods

- (void)registerPush {
  
  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
  } else {
    // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNAuthorizationOptions authOptions =
    UNAuthorizationOptionAlert
    | UNAuthorizationOptionSound
    | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter]
     requestAuthorizationWithOptions:authOptions
     completionHandler:^(BOOL granted, NSError * _Nullable error) {
     }
     ];
    
    // For iOS 10 display notification (sent via APNS)
    
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:[[UIApplication sharedApplication] delegate]];
    // For iOS 10 data message (sent via FCM)
    //[[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
  }
  
  [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  SNMPushInstallationLog *log = [[SNMPushInstallationLog alloc] init];

  log.installationId =  [[SNMSonoma installId] UUIDString];
  log.pushChannel = [self getDeviceTokenString:deviceToken];
  
  NSArray *tags = @[self.deviceTracker.device.appVersion,
                   self.deviceTracker.device.sdkVersion,
                   self.deviceTracker.device.osName,
                   self.deviceTracker.device.screenSize,
                   self.deviceTracker.device.locale,
                   self.deviceTracker.device.osVersion,
                   self.deviceTracker.device.appBuild];
  log.tags = tags;
  
  [self.logManager processLog:log withPriority:SNMPriorityHigh];
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error; {

}

- (NSString *)getDeviceTokenString:(NSData *)deviceToken {
  if (!deviceToken)
    return nil;
  
  NSMutableString* stringBuffer = [NSMutableString stringWithCapacity:([deviceToken length] * 2)];
  
  const unsigned char* dataBuffer = [deviceToken bytes];
  int i;
  
  for (i = 0; i < [deviceToken length]; ++i)
  {
    [stringBuffer appendFormat:@"%02x", dataBuffer[i]];
  }
  
  return [NSString stringWithString:stringBuffer];
}

@end
