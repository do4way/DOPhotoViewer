//
//  DOPTestUtils.m
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPTestUtils.h"

@implementation DOPTestUtils

+ (void)waitForVerifiedMock:(OCMockObject *)inMock delay:(NSTimeInterval)inDelay
{
    NSTimeInterval i = 0;
    while (i < inDelay)
    {
        @try
        {
            NSLog(@"--wait %f",i);
            [inMock verify];
            return;
        }
        @catch (NSException *e) {
            NSLog(@"--exception:%@", e);
        }
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        i+=0.5;
    }
    [inMock verify];
}

@end
