//
//  AcronymTableViewController.m
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/3/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import "AcronymTableViewController.h"
#import "AcronymTableCell.h"
#import <MBProgressHUD.h>
#import "RequestManager.h"
#import "Acronym.h"
#import "Common.h"
@interface AcronymTableViewController ()<MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtURL;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) MBProgressHUD *activityIndicator;

@end

@implementation AcronymTableViewController

-(MBProgressHUD *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        _activityIndicator.delegate = self;
        _activityIndicator.labelText = kLoading;
        _activityIndicator.square = YES;
        [self.navigationController.view addSubview:_activityIndicator];
    }
    return _activityIndicator;
}
#pragma mark API Call

-(void)getAcronymFromAPI
{
    [self.activityIndicator show:YES];
    NSString *string  = self.txtURL.text;
    
    __weak typeof(self) weakSelf = self;
    [RequestManager getAcronymForString:string fromDataSource:DATA_SOURCE_ANY withCompletion:^(BOOL success, id result, DSErrorCode errorCode) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {
            NSLog(@"Is main Thread %@",[NSThread isMainThread] ? @"YES" : @"NO");
            strongSelf.dataSource = (NSArray *)result;
            [strongSelf.tableView reloadData];
            [strongSelf.activityIndicator hide:YES];
        } else {
            [strongSelf handleError:errorCode];
            [strongSelf.activityIndicator hide:YES];
        }
    }];
}

-(void)handleError:(DSErrorCode)error{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:kError
                                  message:kError
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:kOK
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)setUP
{
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
-(void)awakeFromNib
{
    [self setUP];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf getAcronymFromAPI];
    });
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AcronymTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    Acronym *iObject = self.dataSource[indexPath.row];
    [cell linkTableCellWithDataModel:iObject];
    
    return cell;
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.tableView reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Acronym *iObject = self.dataSource[indexPath.row];
    AcronymTableViewController *destViewController = segue.destinationViewController;
    destViewController.dataSource = iObject.vars;
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark IBAction

- (IBAction)search:(id)sender
{
    if ([self isValidText]) {
        [self.txtURL resignFirstResponder];
        [self getAcronymFromAPI];
    }else{
        [self requiredFieldError];
    }
    
}

-(BOOL)isValidText
{
    BOOL retValue = NO;
    if ([self.txtURL.text isEqualToString:@""]) {
        retValue = NO;
    }else{
        retValue = YES;
    }
    return retValue;
}

-(void)requiredFieldError{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:kError
                                  message:kMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:kOK
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
