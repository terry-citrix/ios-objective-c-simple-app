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
    }];
    return YES;
}
```

You'll then get a warning that `Class 'AppDelegate' does not conform to protocol 'CTXMAMComplianceDelegate'`.  Click on the option to fix it by generating the stubs.

It will add a number of functions to your App Delegate.  For now, just modify each one so that it returns YES.

### Generate MDX file

Click on your project at the top of your navigation window in the left-hand pane, then click on your app name under **Targets** in the middle pane, and select the **Build Phases** tab.

Click on the small **+** sign to the right of the project and then select **New Run Script Phase**.

Copy the following script into the editable text section:

```bash
#WARNING: Ensure that no hidden characters are added to the file in the process of copying contents. Some editors will add formatting data when copying from them.

export STOREURL="http://yourstore.yourdomain.com" #STOREURL can be set to any URL during development (e.g., http://yourstore.yourdomain.com). The URL may need to be changed later depending on the distribution method selected.

export APPTYPE="sdkapp" #APPTYPE should be set to sdkapp for apps that use the iOS MAM SDK, as this is the only valid option. Since the iOS MAM SDK is built into the app, XCode can prepare the app like any other Apple applications. Consequently less post-build preparation is needed than when performing an MDX app wrapping.

export PACKAGEID="DE398570-6D5E-4DE8-BC13-BB1814BBB412" #Please run uuidgen on the terminal and paste the output value in PACKAGEID. This has be the same UUID which was generated when adding the URL Type.

export APPIDPREFIX="LKQN7Jfake" #APPIDPREFIX should be set to the Team ID that is located in the Apple Developer Account.

export TOOLKIT_DIR="$PROJECT_DIR/Tools"

if [ -z "${PACKAGEID}" ]
then
    echo "PACKAGEID variable was not found or was empty, please run uuidgen at the command line and paste the output value in the PACKAGEID variable in your post build script."
    exit 1
fi

if [ -z "${APPIDPREFIX}" ]
then
    echo "APPIDPREFIX variable was not found or was empty, please refer to the \"how to\" document located in the documentation folder of the SDK package on where to find your Apple's application prefix ID."
    exit 1
fi

if [ ! -d $TOOLKIT_DIR/logs ]
then
    mkdir $TOOLKIT_DIR/logs
fi

"$TOOLKIT_DIR/CGAppCLPrepTool" SdkPrep -in "$CONFIGURATION_BUILD_DIR/$EXECUTABLE_FOLDER_PATH" -out "$CONFIGURATION_BUILD_DIR/$EXECUTABLE_NAME.mdx" -storeURL "${STOREURL}" -appType "${APPTYPE}" -packageId "${PACKAGEID}" -entitlements "$SRCROOT/$PROJECT/$PROJECT.entitlements" -appIdPrefix "${APPIDPREFIX}" -minPlatform "9.0"

```
### MDX File

After you rebuild the project, you'll find the generated MDX file in your **DerivedData** folder, which if you followed the suggestion will be located at the root of your project directory.

The path will be `DerivedData\<appName>\Build\Products\Debug-iphonesimulator\`.

