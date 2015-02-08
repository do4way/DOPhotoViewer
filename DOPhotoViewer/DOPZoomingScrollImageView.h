//
//  DOPZoomingScrollImageView.h
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/16.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DOPUrlPhoto;
@protocol DOPhotoViewerDelegate;

@interface DOPZoomingScrollImageView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id<DOPhotoViewerDelegate> photoViewerDelegate;

- (instancetype) initWithFrame:(CGRect)frame photo:(DOPUrlPhoto *) photo;
- (void) loadPhoto:(DOPUrlPhoto *) photo;
- (void) scaleToFitScreen;

@end
