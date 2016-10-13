/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "SNMPush.h"
#import "SNMPushCategory.h"
#import <objc/runtime.h>

static NSString *const kSNMViewControllerSuffix = @"ViewController";


BOOL snm_shouldTrackPageView(UIViewController *viewController) {

  // For container view controllers, auto page tracking is disabled(to avoid
  // noise).
  NSSet *viewControllerSet = [NSSet setWithArray:@[
    @"UINavigationController",
    @"UITabBarController",
    @"UISplitViewController",
    @"UIInputWindowController",
    @"UIPageViewController"
  ]];
  NSString *className = NSStringFromClass([viewController class]);

  return ![viewControllerSet containsObject:className];
}

@implementation SNMPushCategory

+ (void)activateCategory {
  [SNMPushCategory swizzleDidRegisterForRemoteNotificationsWithDeviceToken];
}

+ (void)swizzleDidRegisterForRemoteNotificationsWithDeviceToken {
  
//  UIApplication *app = [UIApplication sharedApplication];
//  id<UIApplicationDelegate> appDelegate = app.delegate;
//  Method didRegisterMethod = class_getInstanceMethod([SNMPushCategory class], @selector(my_application:didRegisterForRemoteNotificationsWithDeviceToken:));
//  IMP didRegisterMethodImp = method_getImplementation(didRegisterMethod);
//  const char* didRegisterTypes = method_getTypeEncoding(didRegisterMethod);
//  
//  Method didRegisterOriginal = class_getInstanceMethod(appDelegate.class, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:));
//  if (didRegisterOriginal) {
//    didRegisterOriginalMethod = method_getImplementation(didRegisterOriginal);
//    method_exchangeImplementations(didRegisterOriginal, didRegisterMethod);
//  } else {
//    class_addMethod(appDelegate.class, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), didRegisterMethodImp, didRegisterTypes);
//  }
//  
//  
//  
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    Class class = [self class];
//    
//    // Get selectors.
//    SEL originalSelector = @selector(viewWillAppear:);
//    SEL swizzledSelector = @selector(snm_viewWillAppear:);
//    
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//    
//    method_exchangeImplementations(originalMethod, swizzledMethod);
//  });
}


@end
