//
//  DOPPhotoViewController.m
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/16.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPPhotoViewController.h"
#import "DOPZoomingScrollImageView.h"
#import "DOPUrlPhoto.h"


@interface DOPPhotoViewController () <DOPhotoViewerDataSource>


@end

@implementation DOPPhotoViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSourceDelegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark - DOPhoto viewer data source delegate

- (NSUInteger) numberOfPhotos
{
    return 2;
}

- (NSURL *) photoUrlAtIndex:(NSUInteger)idx
{
    NSArray* urls = @[@"http://farm6.staticflickr.com/5531/9326895814_f02a70fe25_o.jpg",
                      @"http://farm8.staticflickr.com/7287/9661054311_c7a2f82db8_o.jpg"];
    return urls[idx];
    
}

@end
