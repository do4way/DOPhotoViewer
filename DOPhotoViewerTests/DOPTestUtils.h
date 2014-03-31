//
//  DOPTestUtils.h
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OCMock/OCMock.h>

@interface DOPTestUtils : NSObject
+ (void)waitForVerifiedMock:(OCMockObject *)mock delay:(NSTimeInterval)delay;
@end
