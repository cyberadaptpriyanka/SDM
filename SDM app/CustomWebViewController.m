//
//  CustomWebViewController.m
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "CustomWebViewController.h"
#import "AppDelegate.h"

@interface CustomWebViewController ()


@property ( nonatomic , strong ) UIViewController *viewController ;
@property ( nonatomic , strong ) UIActivityIndicatorView *activityIndicator;
@end
@implementation CustomWebViewController



#pragma mark Viewcontroller life cycle
- ( void )viewDidLoad {
  [super viewDidLoad];
    [ self addCloseButton];

}

- ( void ) viewWillAppear : (BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma  mark Self methods
- ( instancetype )initWithURL : (NSURL *)url {
  
  return [self initWithURLRequest:[NSURLRequest requestWithURL:url]];
}

- ( instancetype ) initWithURLRequest : (NSURLRequest *)request {
  
    //Configure the viewcontroller with webview
  if (_viewController == nil) {
    _viewController  = [[UIViewController alloc] init];
    
    _webView = [[WKWebView alloc] initWithFrame:_viewController.view.frame];
    _webView.navigationDelegate = self;
    
    [ _webView loadRequest:request ];
    [ _viewController.view addSubview:_webView ];
    _activityIndicator = [[UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.center = _viewController.view.center;
    [ _activityIndicator startAnimating ];
    [ _viewController.view addSubview:_activityIndicator];
    
  }
  if (self = [super initWithRootViewController:_viewController]) {
    
  }
  return self;
}

#pragma  mark Custom methods
- ( void )addCloseButton {
  
  UIBarButtonItem *closeButton = [[UIBarButtonItem alloc ] initWithTitle:@"Close"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(dismissController)];
  
  [ closeButton setTintColor:[UIColor colorWithRed:34.0f/255.0f green:117.0f/255.0f
                                              blue:184.0f/255.0f alpha:1.0]];
  UIFont *font = [UIFont systemFontOfSize:20];
  NSDictionary *fontAttribute = @{@"NSFontAttributeName":font};
  [ closeButton setTitleTextAttributes:fontAttribute forState:UIControlStateNormal];
  [ self.viewController.navigationItem setLeftBarButtonItem:closeButton ];
}

  // dissmiss viewcontroller
- ( void )dismissController {
  //NSLog(@"%s",__PRETTY_FUNCTION__);
  [ self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark ActivityIndicator Methods
- ( void )startAnimating {
  if ( nil != _activityIndicator ) {
    [ _activityIndicator startAnimating ];
  }
  
}
- ( void )stopAnimating {
  if ( nil != _activityIndicator ) {
    [ _activityIndicator stopAnimating ];
    
  }
  
}
- (BOOL )isAnimating {
  if ( nil != _activityIndicator ) {
    return  [ _activityIndicator isAnimating ];
  }
  return  NO;
  
}

#pragma  mark WKNavigationDelegates
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  [ self stopAnimating ];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
  [ self stopAnimating ];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {

  [ self stopAnimating ];
}

@end
