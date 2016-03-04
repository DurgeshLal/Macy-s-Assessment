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
@end
