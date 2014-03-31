//
//  DOPSliderPhotoViewerViewController.h
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOPhotoViewerProtocols.h"

@interface DOPSliderPhotoViewerViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet id<DOPhotoViewerDataSource> dataSourceDelegate;


@end
