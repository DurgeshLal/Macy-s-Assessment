//
//  AcronymTableCell.h
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Acronym.h"

@interface AcronymTableCell : UITableViewCell

-(void)linkTableCellWithDataModel:(Acronym *)iObject;

@end
