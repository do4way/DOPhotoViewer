//
//  DOPSliderPhotoViewerViewController.m
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPSliderPhotoViewerViewController.h"
#import "DOPhotoViewerProtocols.h"
#import "DOPZoomingScrollImageView.h"
#import "DOPUrlPhoto.h"

#define PADDING                 10

@interface DOPSliderPhotoViewerViewController ()

@property (nonatomic, strong) NSMutableArray *pages;
@property (nonatomic, strong) UIScrollView   *pagingScrollView;
@property (nonatomic) NSUInteger currentPageIndex;

@end

@implementation DOPSliderPhotoViewerViewController


#pragma mark - view loading

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    [self preparePagingScrollView];
    [self createPages];
    self.currentPageIndex = [self __startAtPage];
    [self scrollToPage: self.currentPageIndex];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initialization
- (void) preparePagingScrollView
{
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    _pagingScrollView = [[UIScrollView alloc] initWithFrame: pagingScrollViewFrame];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                         UIViewAutoresizingFlexibleHeight;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.delegate = self;
    _pagingScrollView.showsHorizontalScrollIndicator = NO;
    _pagingScrollView.showsVerticalScrollIndicator = NO;
    _pagingScrollView.backgroundColor = [UIColor blackColor];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:_currentPageIndex];
    
    [self.view addSubview:_pagingScrollView];
}


#pragma mark - Layout

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}


#pragma mark - UIScrollView Delegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.pagingScrollView.frame);
    NSUInteger page = floor((self.pagingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPageIndex = page;
    [self scrollToPage:self.currentPageIndex];
    
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    _pagingScrollView.frame = pagingScrollViewFrame;
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    NSUInteger idx = 0;
    for (DOPZoomingScrollImageView* page in self.pages ) {
        if ((NSNull *) page != [NSNull null]) {
            [page scaleToFitScreen];
            page.frame = [self frameForPageAtIndex:idx++];
            
        }
    }
    CGRect bounds = self.pagingScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * self.currentPageIndex;
    bounds.origin.y = 0;
    [self.pagingScrollView scrollRectToVisible:bounds animated:NO];
    
}

#pragma mark - tap gesture recognizer 
- (void) onTapped:(UIGestureRecognizer*) sender
{
    if (sender.state == UIGestureRecognizerStateEnded ) {
        
        NSLog(@"single tapped");
    }
}


#pragma mark - private methods
- (void) createPages
{
    self.pages = [[NSMutableArray alloc] init];
    NSUInteger numberOfPhotos = [self __numberOfPhotos];

    
    for (NSUInteger idx = 0; idx < numberOfPhotos; idx++)
    {
        DOPZoomingScrollImageView *view = [[DOPZoomingScrollImageView alloc] init];
        NSLog(@"view controller photoview delegate: %@", self.delegate);
        NSLog(@"datasource delegate: %@", self.dataSourceDelegate);
        [view setPhotoViewerDelegate:self.delegate];
        [self.pages addObject:view];
    }
}

- (void) loadPageAtIndex:(NSUInteger) idx
{
    if (idx >= [self __numberOfPhotos] ) return;
    DOPZoomingScrollImageView* page = [self.pages objectAtIndex:idx];
    
    if ((NSNull *) page == [NSNull null]) {
        page = [[DOPZoomingScrollImageView alloc] init];
        [self.pages replaceObjectAtIndex:idx withObject:page];
        
    }
    
    if ( page.superview == nil ) {
        CGRect pageFrame = [self frameForPageAtIndex:idx];
        page.frame = pageFrame;
        DOPUrlPhoto* photo = [DOPUrlPhoto photoWithURL:[self __photoUrlAtIndex:idx]];
        [page loadPhoto:photo];
        [self.pagingScrollView addSubview:page];
    }
    
}

- (void) scrollToPage:(NSInteger) idx
{
    self.currentPageIndex = idx;
    [self loadPageAtIndex:idx];
	_pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:_currentPageIndex ];
    
    [self loadPageAtIndex:(idx+1)];
    if (idx > 0 ) {
        [self loadPageAtIndex:(idx-1)];
    }
    
    
}


- (CGRect) frameForPagingScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return CGRectIntegral(frame);
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return CGRectIntegral(pageFrame);
}

- (CGSize) contentSizeForPagingScrollView
{
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self __numberOfPhotos], bounds.size.height);
}


- (CGPoint) contentOffsetForPageAtIndex:(NSUInteger) idx
{
    CGFloat pageWidth = self.pagingScrollView.bounds.size.width;
    CGFloat newOffset = idx * pageWidth;
    return CGPointMake(newOffset,0);
}

- (NSUInteger) __numberOfPhotos
{
    return [self.dataSourceDelegate numberOfPhotos];
}

- (NSURL *) __photoUrlAtIndex: (NSUInteger) idx
{
    return [self.dataSourceDelegate photoUrlAtIndex:idx];
}

- (NSUInteger) __startAtPage{
    if ([self.dataSourceDelegate respondsToSelector:@selector(startAtPage)])
        return [self.dataSourceDelegate startAtPage];
    return 0;
}

@end
