//
//  RequestBuilder.m
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import "RequestBuilder.h"
#import "Common.h"

@implementation RequestBuilder

-(NSString *)getBaseURL
{
    return baseURL;
}

-(NSDictionary *)getParameterForAcronymWithNstring:(NSString *)string
{
    return @{@"sf" : string};
}


@end
