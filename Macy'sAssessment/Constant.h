//
//  Constant.h
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_VALID_OBJECT(x) ((x) != nil && [(x) class] != [NSNull class])
#define IS_VALID_ARRAY(x) (IS_VALID_OBJECT(x) && (x).count > 0)

extern NSString *const baseURL;

typedef enum DataSource {
    DATA_SOURCE_ANY,
    DATA_SOURCE_CHACHE,
    DATA_SOURCE_NETWORK,
} DataSource;

typedef enum DSErrorCode : NSInteger {
    DSErrorNone = 9000,
    DSErrorOffline,
    DSErrorNoContent
} DSErrorCode;

typedef void (^DSCompletion)(BOOL success, id result, DSErrorCode errorCode);

@interface Constant : NSObject

@end
