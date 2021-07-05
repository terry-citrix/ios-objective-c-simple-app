//
//  AppDelegate.m
//  ios-simple-app
//
//  Created by Terry Duchastel on 6/29/21.
//

#import "AppDelegate.h"
#import <CTXMAMCore/CTXMAMCore.h>
#import <CTXMAMCompliance/CTXMAMCompliance.h>
#import <CTXMAMContainment/CTXMAMContainment.h>
#import <CTXMAMLocalAuth/CTXMAMLocalAuth.h>

@interface AppDelegate () <CTXMAMCoreSdkDelegate,
                           CTXMAMComplianceDelegate,
                           CTXMAMContainmentSdkDelegate,
                           CTXMAMLocalAuthSdkDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    [CTXMAMCore setDelegate:self];
    [CTXMAMLocalAuth setDelegate:self];
    [CTXMAMContainment setDelegate:self];
    [CTXMAMCompliance sharedInstance].delegate = self;
    
    [CTXMAMCore initializeSDKsWithCompletionBlock:^(NSError * _Nullable nilOrError) {
        NSLog(@"Citrix MAM SDK has been initialized!");
    }];
    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


- (BOOL)handleAdminLockAppSecurityActionForError:(nonnull NSError *)error {
    return YES;
}

- (BOOL)handleAdminWipeAppSecurityActionForError:(nonnull NSError *)error {
    return YES;
}

- (BOOL)handleAppDisabledSecurityActionForError:(nonnull NSError *)error {
    return YES;
}

- (BOOL)handleContainerSelfDestructSecurityActionForError:(nonnull NSError *)error {
    return YES;
}

- (BOOL)handleDateAndTimeChangeSecurityActionForError:(nonnull NSError *)error {
    return YES;
}

- (BOOL)handleDevicePasscodeComplianceViolationForError:(nonnull NSError *)error {
    return YES;
}

- (BOOL)handleEDPComplianceViolationForError:(nonnull NSError *)error {
    return YES;
}

- (BOOL)handleJailbreakComplianceViolationForError:(nonnull NSError *)error {
    return YES;
}

- (BOOL)handleUserChangeSecurityActionForError:(nonnull NSError *)error {
    return YES;
}

@end
