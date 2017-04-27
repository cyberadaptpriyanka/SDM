//
//  APIManager.h
//  SDM app

//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef void (^ArrayCompletionBlock)(id, NSError *error);

@interface APIManager : AFHTTPSessionManager

+ (APIManager *)sharedAPIManager;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)destroyInstance;

- (void)loginWithUsername:(NSString *)userName password:(NSString *)password
                           completion:(ArrayCompletionBlock)completion;

@end
