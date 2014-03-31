//
//  DOPhotoViewerDataSource.h
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOPURLPHOTO_LOADING_DID_END_NOTIFICATION @"DOPURLPHOTO_LOADING_DID_END_NOTIFICATION"
#define DOPURLPHOTO_PROGRESS_NOTIFICATION        @"DOPURLPHOTO_PROGRESS_NOTIFICATION"

@protocol DOPhotoViewerDataSource <NSObject>

@required

- (NSUInteger) numberOfPhotos;
- (NSURL *)    photoUrlAtIndex:(NSUInteger) idx;

@optional
- (NSUInteger) startAtPage;

@end
