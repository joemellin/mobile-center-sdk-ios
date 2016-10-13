#import "AppDelegate.h"
#import "Constants.h"
#import "SonomaAnalytics.h"
#import "SonomaCore.h"
#import "SonomaCrashes.h"
#import "SonomaPush.h"

#import "SNMErrorAttachment.h"
#import "SNMErrorReport.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Start Sonoma SDK.
  [SNMSonoma setLogLevel:SNMLogLevelVerbose];

  [SNMSonoma setServerUrl:@"http://in-memoz-001.dev.avalanch.es:8081"];
  [SNMSonoma start:@"90fa0c95-114d-4c26-91f0-5d0411c49bd7" withFeatures:@[ [SNMAnalytics class], [SNMCrashes class], [SNMPush class]]];

  if ([SNMCrashes hasCrashedInLastSession]) {
    SNMErrorReport *errorReport = [SNMCrashes lastSessionCrashReport];
    NSLog(@"We crashed with Signal: %@", errorReport.signal);
  }

  // Print the install Id.
  NSLog(@"%@ Install Id: %@", kPUPLogTag, [[SNMSonoma installId] UUIDString]);
  
  [SNMPush registerPush];

  return YES;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
  [SNMPush didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
  [SNMPush didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo {
  NSLog(@"%@", userInfo);
  [self MessageBox:@"Notification" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"]];
}

-(void)MessageBox:(NSString *)title message:(NSString *)messageText
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:messageText delegate:self
                                        cancelButtonTitle:@"OK" otherButtonTitles: nil];
  [alert show];
}


@end
