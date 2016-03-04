//
//  Acronym.m
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import "Acronym.h"

@implementation Acronym

-(instancetype)initWithData:(NSDictionary *)data;
{
    self = [super init];
    if (self) {
        _freq = data[@"freq"] ? data[@"freq"] : [NSNull null];
        _lf = data[@"lf"] ? data[@"lf"] : [NSNull null];
        _since = data[@"since"] ? data[@"since"] : [NSNull null];
        
        // Since dataSource Schema is similar, Can recursively use same Model Class to parse.
        if ([[data allKeys] containsObject:@"vars"]) {
            // contains a child object
            NSMutableArray *retValue = [NSMutableArray new];
            NSArray *childObjects = data[@"vars"];
            for (NSDictionary *child in childObjects) {
                [retValue addObject:[self initWithData:child]];
            }
            _vars = [NSArray arrayWithArray:retValue];
        }
    }
    return self;
}

@end
