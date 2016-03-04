//
//  AcronymTableCell.m
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import "AcronymTableCell.h"
@interface AcronymTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblAcronym;

@end

@implementation AcronymTableCell


-(void)linkTableCellWithDataModel:(Acronym *)iObject
{
    self.lblAcronym.text = iObject.lf;
}
-(void)prepareForReuse
{
    self.lblAcronym.text = @"";
}
@end
