//
//  DOPPhotoViewController.h
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/16.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOPSliderPhotoViewerViewController.h"
#import "DOPhotoViewerProtocols.h"
@protocol DOPhotoViewerDelegate;
@protocol DOPhotoViewerDataSource;

@interface DOPPhotoViewController : DOPSliderPhotoViewerViewController<DOPhotoViewerDataSource, DOPhotoViewerDelegate>

@end
