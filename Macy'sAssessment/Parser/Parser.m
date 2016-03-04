//
//  Parser.m
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import "Parser.h"
#import "Acronym.h"

@implementation Parser
+(void)parseData:(id)data withCompletionHandler:(DSCompletion)comp
{
    // Would like to early exit in case response is an empty array, Thanks to Apple for there gaurd statement in swift. But still a pain in Objective-C
    if (!IS_VALID_ARRAY((NSArray *)data)) {
        comp(YES,@[], DSErrorNoContent);
        return;
    }
    
    NSMutableArray *retValue = [NSMutableArray new];
    NSArray *responseData = (NSArray *)data[0][@"lfs"];
    
    if (![responseData isKindOfClass:[NSArray class]]) {
        comp(NO,nil,DSErrorNoContent);
        return;
    }
    for (NSDictionary *dataDict in responseData) {
        Acronym *iObject = [[Acronym alloc] initWithData:dataDict];
        [retValue addObject:iObject];
    }
    comp(YES,retValue, DSErrorNone);
}
@end
