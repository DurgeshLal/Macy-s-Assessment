//
//  RequestManager.h
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
@interface RequestManager : NSObject
+ (void) getAcronymForString:(NSString *)string
              fromDataSource:(DataSource)dataSource
              withCompletion:(DSCompletion)completion;

/*
// Singleton Version of API call.
- (void) getAcronymForString:(NSString *)string
              fromDataSource:(DataSource)dataSource
              withCompletion:(DSCompletion)completion;

- (instancetype)init __attribute__((unavailable("init not available, use sharedManager instead")));
+(instancetype)sharedManager;
 */
@end
