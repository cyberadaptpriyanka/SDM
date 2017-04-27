//
//  CustomWebViewController.h
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
  //A CustomWebViewController is a Generic webview controller to display
  //webcontent with navigation bar close button.


@interface CustomWebViewController : UINavigationController < WKNavigationDelegate >

@property ( nonatomic , strong ) NSString *url;
@property ( nonatomic , readonly ) WKWebView *webView;

  // instantiate with URL

- ( instancetype )initWithURL:(NSURL *)url;


@end
