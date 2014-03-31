//
//  DOPZoomingScrollImageView.m
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/16.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPZoomingScrollImageView.h"
#import "DACircularProgressView.h"
#import "DOPCommon.h"
#import "DOPUrlPhoto.h"

@interface DOPZoomingScrollImageView()

@property (nonatomic,strong) DOPUrlPhoto* photo;
@property (nonatomic, strong) UIImageView* photoImageView;
@property (nonatomic, strong) DACircularProgressView* loadingIndicator;

@end

@implementation DOPZoomingScrollImageView

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self initPhotoImageView];
        [self initLoadIndicator];
        [self registerNotificationObserver];
        [self addTapGestureRecgnizer];
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
    
}


- (instancetype) initWithFrame:(CGRect)frame photo:(DOPUrlPhoto *)photo
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadPhoto:photo];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification observer

- (void) onImageLoading:(NSNotification *) notification
{
    NSDictionary *dict = [notification object];
    DOPUrlPhoto* photoInProgress = [dict objectForKey:@"photo"];
    if (photoInProgress == self.photo) {
        float progress = [[dict valueForKey:@"progress"] floatValue];
        self.loadingIndicator.progress = MAX(MIN(1, progress), 0);
    }
}

- (void) onImageLoadCompleted:(NSNotification *) notification
{
    DOPUrlPhoto* photoLoaded= [notification object];
    if ( photoLoaded == self.photo ) {
        UIImage *image = photoLoaded.image;
        if (image) {
            [self hideIndicator];
            [self displayImage:image];
        }
#pragma TODO - show load image failure
        
    }
}


#pragma mark - Layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    if (!_loadingIndicator.hidden) {
        _loadingIndicator.frame = CGRectMake(floorf((self.bounds.size.width - _loadingIndicator.frame.size.width) / 2.0),
                                             floorf((self.bounds.size.height - _loadingIndicator.frame.size.height) / 2.0 ), _loadingIndicator.frame.size.width, _loadingIndicator.frame.size.height);
    
        return;
    }
    
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
        frameToCenter.origin.x = 0;
	}
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
        frameToCenter.origin.y = 0;
	}
    
	// Center
	if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
		_photoImageView.frame = frameToCenter;
    
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _photoImageView;
}

#pragma mark - gesture recognizer

- (void) onImageTapped:(UIGestureRecognizer *) gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self];
    CGRect imageFrame = self.photoImageView.frame;
    CGFloat touchX = (point.x - imageFrame.origin.x)/ self.zoomScale + self.contentOffset.x;
    CGFloat touchY = (point.y - imageFrame.origin.y)/ self.zoomScale + self.contentOffset.y;
    
    [self zoomTo:CGPointMake(touchX, touchY)];
    
}

#pragma  mark - private methods

- (void) initPhotoImageView
{
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _photoImageView.backgroundColor = [UIColor blackColor];
    [self addSubview:_photoImageView];
    
}

- (void) initLoadIndicator
{
    _loadingIndicator = [[DACircularProgressView alloc]
                         initWithFrame:CGRectMake(140.0f, 200.0f, 40.0f, 40.0f)];
    _loadingIndicator.userInteractionEnabled = NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        _loadingIndicator.thicknessRatio = 0.1;
        _loadingIndicator.roundedCorners = NO;
    } else {
        _loadingIndicator.thicknessRatio = 0.2;
        _loadingIndicator.roundedCorners = YES;
    }
    _loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                        UIViewAutoresizingFlexibleTopMargin |
                                        UIViewAutoresizingFlexibleRightMargin |
                                        UIViewAutoresizingFlexibleBottomMargin;
    NSLog(@"add indicator, %@", _loadingIndicator);
    [self addSubview:_loadingIndicator];
}

- (void) registerNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onImageLoading:)
                                                 name:DOPURLPHOTO_PROGRESS_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onImageLoadCompleted:)
                                                 name:DOPURLPHOTO_LOADING_DID_END_NOTIFICATION
                                               object:nil];
}

- (void) addTapGestureRecgnizer
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(onImageTapped:)];
    [tapRecognizer setNumberOfTapsRequired:2];
    [self addGestureRecognizer:tapRecognizer];
}



- (void) displayImage:(UIImage *) image
{
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    _photoImageView.image = image;
    _photoImageView.hidden = NO;
    
    CGRect photoImageViewFrame;
    photoImageViewFrame.origin = CGPointZero;
    photoImageViewFrame.size = image.size;
    _photoImageView.frame = photoImageViewFrame;
    [self toggleFullscreen:YES];
    [self scaleToFitScreen];
    
}

- (void) zoomTo:(CGPoint) touchPoint
{
    // Zoom
	if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
		
		// Zoom out
        CGFloat zoomScale = [self initialZoomScaleWithMinScale];
        
		[self setZoomScale:zoomScale animated:YES];
		
	} else {
		
		// Zoom in to twice the size
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        
        
	}
}

#pragma mark - public method

- (void) scaleToFitScreen
{
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    if ( _photoImageView.image == nil ) return;
    // Reset position
	_photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
    
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.image.size;
    
    CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    
    CGFloat minScale = MIN(xScale, yScale);
    
    CGFloat maxScale = 3;
    
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    
    self.zoomScale = [self initialZoomScaleWithMinScale];
    

    if ( self.zoomScale != minScale) {
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
    }
    
}

- (void) loadPhoto:(DOPUrlPhoto *) photo
{
        _photo = photo;
        [_photo loadImageAndNotify];
    
}

#pragma mark - private methods

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (_photoImageView ) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _photoImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
        
    }
    return zoomScale;
}

- (void) hideIndicator
{
    self.loadingIndicator.hidden = YES;
}

- (void)toggleFullscreen:(BOOL) fullscreen
{
    
    //UINavigationBar *navBar = self.navigationController.navigationBar;
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    float animationDuration;
    if(statusBarFrame.size.height > 20) { // in-call
        animationDuration = 0.5;
    } else { // normal status bar
        animationDuration = 0.6;
    }
    
    if (fullscreen) {
        // Change to fullscreen mode
        // Hide status bar and navigation bar
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationNone];
        
    } else {
        // Change to regular mode
        // Show status bar and navigation bar
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationSlide];
    }
    
}

@end
