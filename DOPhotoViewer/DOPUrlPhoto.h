//
//  DOPhoto.h
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOPhotoViewerProtocols.h"
#import <UIKit/UIKit.h>

@interface DOPUrlPhoto : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly, copy) NSURL* url;


+ (DOPUrlPhoto *) photoWithURL:(NSURL *)url;

- (instancetype) initWithUrl:(NSURL *) url;
- (void) loadImageAndNotify;
- (void) cancelLoading;
- (void) postCompleteNotification;
@end
