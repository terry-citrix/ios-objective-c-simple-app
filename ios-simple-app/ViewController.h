//
//  ViewController.h
//  ios-simple-app
//
//  Created by Terry Duchastel on 6/29/21.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@property NSString* initialUrl;

@end

