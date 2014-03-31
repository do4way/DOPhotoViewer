//
//  DOPUrlPhotoTest.m
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DOPUrlPhoto.h"
#import "DOPhotoViewerProtocols.h"
#import "DOPTestUtils.h"

@interface DOPUrlPhotoTest : XCTestCase

@end

@implementation DOPUrlPhotoTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.

}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testLoadImageAndNotify
{
    id observerMock = [OCMockObject observerMock];
    DOPUrlPhoto* photo = [DOPUrlPhoto photoWithURL:[NSURL URLWithString:@"http://farm6.staticflickr.com/5200/6947016398_2a9a8cb3aa_o.jpg"]];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:DOPURLPHOTO_LOADING_DID_END_NOTIFICATION
                                                   object:photo];
    [[observerMock expect] notificationWithName:DOPURLPHOTO_LOADING_DID_END_NOTIFICATION
                                         object:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSLog(@"--loaded photo:%@", photo.image);
        XCTAssertNotNil(photo.image,@"photo image should not be null");
        
    }]];
    [photo loadImageAndNotify];
    
    [DOPTestUtils waitForVerifiedMock:observerMock delay:10];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

@end
