//
//  Acronym.h
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Acronym : NSObject

@property (nonatomic, strong) NSNumber *freq;
@property (nonatomic, strong) NSString *lf;
@property (nonatomic, strong) NSNumber *since;
@property (nonatomic, strong) NSArray *vars;
-(instancetype)initWithData:(NSDictionary *)data;

@end
