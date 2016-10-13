/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */


#import "SNMPushInstallationLog.h"
static NSString *const kSNMTypePushInstallationType = @"push_installation";

static NSString *const kSNMPushInstallationId = @"installation_id";
static NSString *const kSNMPushChannel = @"push_channel";
static NSString *const kSNMPushPlatform = @"platform";
static NSString *const kSNMPushTags = @"tags";

@implementation SNMPushInstallationLog

@synthesize type = _type;

- (instancetype)init {
  if (self = [super init]) {
    _type = kSNMTypePushInstallationType;
    _platform = @"apns";
  }
  return self;
}

- (NSMutableDictionary *)serializeToDictionary {
  NSMutableDictionary *dict = [super serializeToDictionary];
  
  if (self.installationId) {
    dict[kSNMPushInstallationId] = self.installationId;
  }
  if (self.pushChannel) {
    dict[kSNMPushChannel] = self.pushChannel;
  }

  if (self.platform) {
    dict[kSNMPushPlatform] = self.platform;
  }

  if (self.tags) {
    dict[kSNMPushTags] = self.tags;
  }

  return dict;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    _type = [coder decodeObjectForKey:kSNMTypePushInstallationType];
    _installationId = [coder decodeObjectForKey:kSNMPushInstallationId];
    _pushChannel = [coder decodeObjectForKey:kSNMPushChannel];
    _platform = [coder decodeObjectForKey:kSNMPushPlatform];
    _tags = [coder decodeObjectForKey:kSNMPushTags];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeObject:self.type forKey:kSNMTypePushInstallationType];
  
  [coder encodeObject:self.installationId forKey:kSNMPushInstallationId];
  [coder encodeObject:self.pushChannel forKey:kSNMPushChannel];
  [coder encodeObject:self.platform forKey:kSNMPushPlatform];
  [coder encodeObject:self.tags forKey:kSNMPushTags];
}

@end
