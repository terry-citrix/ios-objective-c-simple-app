# ios-objective-c-simple-app
A very simple iOS Objective-C app that allows you to browse the web.


## Attributions

The icon is licensed as Creative Commons CC0 1.0 Universal Public Domain Dedication, and is from https://commons.wikimedia.org/wiki/File:Kawaii_earth_clipart.svg from the artist Marielle Volz.

The black earth on the launch screen is from NASA and is in the public domain, grabbed from https://commons.wikimedia.org/wiki/File:BlackMarble_2016_rotating_globe_at_night.gif

## Integrate with Citrix MAM SDK

To take this simple iOS Objective-C app and integrate it with the Citrix MAM SDK follow these steps.

### Set Derived Data Location

This is optional, but it will make finding some of the generated files easier.  In Xcode navigate to **File** -> **Project Settings**, and set the **Derived Data** location to **Project-relative Location**.

### Download the Citrix MAM SDK

Go to the [https://github.com/citrix/citrix-mam-sdks/releases](https://github.com/citrix/citrix-mam-sdks/releases) page and download the MAM SDK for iOS.

### Copy Data, Framework, and Tools

Copy the **Data**, **Framework**, and **Tools** folders to the root of your project.

### Add the Frameworks

In Xcode, click on the project in the left-hand navigation pane, then on your app name in the TARGETS section, and in the **General** tab scroll down to the **Frameworks, Libraries, and Embedded Content** and add the *.xcframework files.

Ensure that they are listed as **Embed & Sign**.

### Disable Bitcode

In Xcode click on the project in the left-hand navigation pane, then on your app name in the TARGETS section, and in the **Build Settings** tab scroll down to **Build Options**.

Set **Enable Bitcode** to **No**.

### Add URL Type

In Xcode click on the project in the left-hand navigation pane, then on your app name in the TARGETS section, and in the **Info** tab scroll down to **URL Types**.

Add a new URL type with the following settings:
- Identifier: `com.<organization>.<id>`, for example `com.terry.ios-simple-app`
- URL Scheme: first generate a UUID with the **uuidgen** tool in a terminal, then use the value `com.citrix.sso.<package ID>`.  For example `com.citrix.sso.DE398570-6D5E-4DE8-BC13-BB1814BBB412`

### Add Keychain Sharing

In Xcode click on the project in the left-hand navigation pane, then on your app name in the TARGETS section, and in the **Signing & Capabilities** tab first ensure that you have a Team selected.  

Click on the **+ Capability** button and select **Keychain Sharing**.  This will add a new section to this tab.  Click on the **+** button and add keychain sharing for your project's application bundle identifier as well as the `com.citrix.mdx` group. 

This will add an "<project>.entitlements" file to your project.

### Verify that Everything Builds

This is a good time to ensure that all of the changes you've just made do not disrupt your existing app.

### Modify AppDelegate.m

In your app's `AppDelegate.m` modify it as follows:

```objectivec
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
        [self showAlertMsg:@"Citrix MAM SDK has been initialized."];
    }];
    return YES;
}

-(void)showAlertMsg:(NSString *)alertMsg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray<__kindof UIWindow *> *windows = [UIApplication sharedApplication].windows;
        UIWindow * keyWindow = windows.lastObject;
        UIViewController *topController = keyWindow.rootViewController;

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Citrix Alert"
                                                                       message:alertMsg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        NSString *buttonText = nil;
        buttonText = NSLocalizedString(@"OK", comment="");
        
        UIAlertAction* uiButton = [UIAlertAction actionWithTitle:buttonText
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
        }];
         
        [alert addAction:uiButton];
        [topController presentViewController:alert animated:YES completion:nil];
    });
}
```

You'll then get a warning that `Class 'AppDelegate' does not conform to protocol 'CTXMAMComplianceDelegate'`.  Click on the option to fix it by generating the stubs.

It will add a number of functions to your App Delegate.  For now, just modify each one so that it returns YES.








