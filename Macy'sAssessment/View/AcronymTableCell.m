//
//  AcronymTableCell.m
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import "AcronymTableCell.h"
@interface AcronymTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *freq;
@property (weak, nonatomic) IBOutlet UILabel *since;
@property (weak, nonatomic) IBOutlet UILabel *lf;

@end

@implementation AcronymTableCell


-(void)linkTableCellWithDataModel:(Acronym *)iObject
{
    self.since.text = [NSString stringWithFormat:@"%@",iObject.since];
    self.freq.text = [NSString stringWithFormat:@"%@",iObject.freq];
    self.lf.text = iObject.lf;
}
-(void)prepareForReuse
{
    self.since.text = @"";
    self.freq.text = @"";
    self.lf.text = @"";
}
@end
