//
//  APIManager.m
//  SDM app
//

#import "AFHTTPSessionManager.h"
#import "APIManager.h"

#define BASE_URL @"https://duesterwald.mobileactivedefense.com/"

static APIManager *_sharedAPIManager = nil;

@implementation APIManager

+ (APIManager *)sharedAPIManager
{
    if (_sharedAPIManager == nil) {
        _sharedAPIManager = [[self alloc] initWithBaseURL:
                             [NSURL URLWithString:BASE_URL]];
    }
    
    return _sharedAPIManager;
}

- (void)destroyInstance
{
    _sharedAPIManager = nil;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //Set a custom timeout interval.
        [self.requestSerializer setTimeoutInterval:30];
        [self.requestSerializer setValue:@"application/json"
                      forHTTPHeaderField:@"Content-Type"];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
    }
    
    return self;
}

// Determined method call type and begins service communication
- (NSURLSessionDataTask *) serviceCallWithMethod:(NSString *)method
                                        endpoint:(NSString *)endPoint
                                          params:params
                                         success:(id)success
                                         failure:(id)failure{
    NSURLSessionDataTask *dataTask;
    if ([method isEqualToString:@"POST"]){
        dataTask = [self POST:endPoint parameters:params progress:nil success: success failure: failure];
    }else if ([method isEqualToString:@"GET"]){
        dataTask = [self GET:endPoint parameters:params progress:nil success:success failure:failure];
    }else if ([method isEqualToString:@"PUT"]){
        dataTask = [self PUT:endPoint parameters:params success:success failure:failure];
    }
    
    return dataTask;
}

// Tracks the method and parameters of the last called method
- (NSURLSessionDataTask *)trackCallWithMethod:(NSString *)method
                                    completion:(ArrayCompletionBlock)completion
                                    withParams:(id)params
                                  withEndpoint:(NSString *)endPoint
{
    
    id successBlock = ^(NSURLSessionTask *task, id responseObject){
        NSLog(@"Success Block has been called for: %@,responseObject:%@",
              endPoint, responseObject);
        if (!completion){
            return;
        }
        
        completion(responseObject, nil);
    };
    
    id failureBlock = ^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Failure Block has been called for: %@ error:%@", endPoint,[error description]);
        if(!completion){
            return;
        }
        completion(nil, error);
    };
    
    return  [self serviceCallWithMethod:method endpoint:endPoint params:params success:successBlock failure:failureBlock];
}

#pragma mark - Authentication API Call
- (void)loginWithUsername:(NSString *)userName password:(NSString *)password
               completion:(ArrayCompletionBlock)completion;
{
    NSString *urlString = [NSString stringWithFormat:@"mad-console/seam/resource/ota-ios-app?username=%@&password=%@",userName, password];
    [self trackCallWithMethod:@"GET" completion:completion withParams:nil withEndpoint:urlString];
}

@end
