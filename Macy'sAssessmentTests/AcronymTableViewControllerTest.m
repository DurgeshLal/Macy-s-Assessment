//
//  AcronymTableViewControllerTest.m
//  Macy'sAssessment
//
//  Created by Durgesh Gupta on 3/4/16.
//  Copyright © 2016 Durgesh Gupta. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AcronymTableViewController.h"
#import "RequestManager.h"

@interface AcronymTableViewController ()
-(void)getAcronymFromAPI;
-(BOOL)isValidText;

@end
@interface AcronymTableViewControllerTest : XCTestCase
@property (nonatomic, strong) AcronymTableViewController *vc;
@end

@implementation AcronymTableViewControllerTest

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"AcronymTableViewController"];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.vc = nil;
    [super tearDown];
}

#pragma mark - View loading tests
-(void)testThatViewLoads
{
    XCTAssertNotNil(self.vc.view, @"View not initiated properly");
}


-(void)testThatTableViewLoads
{
    XCTAssertNotNil(self.vc.tableView, @"TableView not initiated");
}

#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.vc.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.vc.tableView.delegate, @"Table delegate cannot be nil");
}

- (void)testIsValidText
{
    XCTAssertTrue([self.vc isValidText], @"Text is not valid");
}

- (void)testRequestManagerApiCall
{
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"HTTP request"];
    
    [RequestManager getAcronymForString:@"USA" fromDataSource:DATA_SOURCE_ANY withCompletion:^(BOOL success, id result, DSErrorCode errorCode) {
        XCTAssertNotNil(result, @"failed to get data");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testCacheMechanismWithOutCachedKeyword
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"HTTP request"];
    // Use some random keyword
    [RequestManager getAcronymForString:@"retuye" fromDataSource:DATA_SOURCE_CHACHE withCompletion:^(BOOL success, id result, DSErrorCode errorCode) {
        XCTAssertTrue(((NSArray *)result).count == 0, @"failed to get data");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testCacheMechanismWithCachedKeyword
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"HTTP request"];
    
    [RequestManager getAcronymForString:@"USA" fromDataSource:DATA_SOURCE_CHACHE withCompletion:^(BOOL success, id result, DSErrorCode errorCode) {
        XCTAssertTrue(((NSArray *)result).count > 0, @"failed to get data");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
    
}
@end
