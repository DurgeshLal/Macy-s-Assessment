//
//  RequestBuilder.h
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBuilder : NSObject

-(NSString *)getBaseURL;
-(NSDictionary *)getParameterForAcronymWithNstring:(NSString *)string;

@end
