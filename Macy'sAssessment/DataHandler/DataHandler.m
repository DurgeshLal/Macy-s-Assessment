//
//  DataHandler.m
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "RequestBuilder.h"
#import "Reachability.h"
#import "DataHandler.h"
#import "Parser.h"

static NSCache *cache;

@implementation DataHandler

+(void) initialize
{
    if (!cache)
        cache = [NSCache new];
}

+ (void) getAcronymForString:(NSString *)string
              fromDataSource:(DataSource)dataSource
              withCompletion:(DSCompletion)completion
{
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

@end
