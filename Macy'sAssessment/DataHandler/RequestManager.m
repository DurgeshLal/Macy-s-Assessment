//
//  RequestManager.m
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "RequestBuilder.h"
#import "Reachability.h"
#import "RequestManager.h"
#import "Parser.h"

@interface RequestManager ()

// Using to cache in singleton Version
@property (nonatomic, strong) NSCache *cacheInSingleton;
@end

static NSCache *cache;

@implementation RequestManager


// Using my API call method a Class methd, hence intializing cache here, This class can be implemented as Singleton as well. Since I have justification that I have a variable to be used though out and I need to initialize that. But this also working for me.
// Check for Singleton Version in Commented code.
+(void) initialize
{
    if (!cache)
        cache = [NSCache new];
}

+ (void) getAcronymForString:(NSString *)string
              fromDataSource:(DataSource)dataSource
              withCompletion:(DSCompletion)completion
{
    // Would Like to make API call with DATA_SOURCE_ANY & let my RequestManager decide from where to get response. Can have diffrenet source like, Cached network, Dat Dist, Web etc.
    // For just a simple demo, Here in NSCache for quick caching mechanism.
    // It will check NSCache first and then go for network in case it failed.
    switch (dataSource) {
        case DATA_SOURCE_CHACHE:
        {
            id response = [cache objectForKey:string];
            if (response) {
                [Parser parseData:response withCompletionHandler:completion];
            } else {
                [self getAcronymForString:string fromDataSource:DATA_SOURCE_NETWORK withCompletion:completion];
            }
        }
            break;
        case DATA_SOURCE_NETWORK:
        {
            BOOL isOnline = ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
            if(!isOnline) {
                completion(NO, @[], DSErrorOffline);
                break;
            }
            
            [self networkRequestWithString:string completionHandler:completion];
        }
            break;
        case DATA_SOURCE_ANY:
        {
            [self getAcronymForString:string fromDataSource:DATA_SOURCE_CHACHE withCompletion:completion];
        }
            break;
            
        default:
            break;
    }
}

/* create request and direct to the parser */
+ (void)networkRequestWithString:(NSString *)string
               completionHandler:(DSCompletion)completion
{
    RequestBuilder *b = [RequestBuilder new];
    NSString *url = [b getBaseURL];
    NSDictionary *parameter = [b getParameterForAcronymWithNstring:string];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
   // manager.responseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        // Track progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            // Cache data and parse
            [cache setObject:responseObject forKey:string];
            [Parser parseData:responseObject withCompletionHandler:completion];
        }else{
            completion (NO,nil, DSErrorNoContent);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion (NO,nil, DSErrorNoContent);
    }];
    
}



/*
//*****************
// Singleton version start here.

+ (instancetype)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceQueue;
    static RequestManager *sharedManager = nil;
    dispatch_once(&onceQueue, ^{
        
        if (sharedManager == nil) {
            sharedManager = [super allocWithZone:zone];
        }
    });
    
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _cacheInSingleton = [NSCache new];
    return self;
}

+(instancetype)sharedManager{
    
    static dispatch_once_t once = 0;
    static RequestManager *sharedManager;
    
    if (sharedManager) {
        return sharedManager;
    }
    
    dispatch_once(&once, ^{
        
        if (!sharedManager) {
            
            sharedManager = [RequestManager new];
        }
    });
    
    return sharedManager;
}

- (void) getAcronymForString:(NSString *)string
              fromDataSource:(DataSource)dataSource
              withCompletion:(DSCompletion)completion
{
    // Would Like to make API call with DATA_SOURCE_ANY & let my RequestManager decide from where to get response. Can have diffrenet source like, Cached network, Dat Dist, Web etc.
    // For just a simple demo, Here in NSCache for quick caching mechanism.
    // It will check NSCache first and then go for network in case it failed.
    switch (dataSource) {
        case DATA_SOURCE_CHACHE:
        {
            id response = [_cacheInSingleton objectForKey:string];
            if (response) {
                [Parser parseData:response withCompletionHandler:completion];
            } else {
                [self getAcronymForString:string fromDataSource:DATA_SOURCE_NETWORK withCompletion:completion];
            }
        }
            break;
        case DATA_SOURCE_NETWORK:
        {
            BOOL isOnline = ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
            if(!isOnline) {
                completion(NO, @[], DSErrorOffline);
                break;
            }
            
            [self networkRequestWithString:string completionHandler:completion];
        }
            break;
        case DATA_SOURCE_ANY:
        {
            [self getAcronymForString:string fromDataSource:DATA_SOURCE_CHACHE withCompletion:completion];
        }
            break;
            
        default:
            break;
    }
}

- (void)networkRequestWithString:(NSString *)string
               completionHandler:(DSCompletion)completion
{
    RequestBuilder *b = [RequestBuilder new];
    NSString *url = [b getBaseURL];
    NSDictionary *parameter = [b getParameterForAcronymWithNstring:string];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // manager.responseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        // Track progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            // Cache data and parse
            [_cacheInSingleton setObject:responseObject forKey:string];
            [Parser parseData:responseObject withCompletionHandler:completion];
        }else{
            completion (NO,nil, DSErrorNoContent);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion (NO,nil, DSErrorNoContent);
    }];
    
}
*/

@end
