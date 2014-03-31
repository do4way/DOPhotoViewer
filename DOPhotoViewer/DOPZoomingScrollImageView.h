//
//  DOPZoomingScrollImageView.h
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/16.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DOPUrlPhoto;

@interface DOPZoomingScrollImageView : UIScrollView <UIScrollViewDelegate>

- (instancetype) initWithFrame:(CGRect)frame photo:(DOPUrlPhoto *) photo;
- (void) loadPhoto:(DOPUrlPhoto *) photo;
- (void) scaleToFitScreen;

@end
