//
//  ViewController.m
//  ios-simple-app
//
//  Created by Terry Duchastel on 6/29/21.
//

#import "ViewController.h"

@implementation ViewController

@synthesize webView = _webView;
@synthesize urlTextField = _urlTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.initialUrl = @"https://citrix.com";
    
    _urlTextField.delegate = self;
    _urlTextField.text = self.initialUrl;
    
    NSURL *url=[NSURL URLWithString:self.initialUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Text field ended editing");
    NSURL *url=[NSURL URLWithString:textField.text];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
   [textField resignFirstResponder];
   return YES;
}


@end
