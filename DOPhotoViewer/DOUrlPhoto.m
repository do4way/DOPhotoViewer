//
//  DOPhoto.m
//  PhotoVIewer
//
//  Created by Yongwei Dou on 2014/03/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPUrlPhoto.h"
#import "SDWebImageManager.h"
#import "SDWebImageOperation.h"

@interface DOPUrlPhoto ()

@property (nonatomic) BOOL loadingInProgress;
@property (nonatomic, readonly, strong) id<SDWebImageOperation> webImageOperation;


- (void) imageLoadingComplete;

@end

@implementation DOPUrlPhoto


#pragma mark - Class Methods


+ (DOPUrlPhoto *) photoWithURL:(NSURL *)url
{
    return [[DOPUrlPhoto alloc] initWithUrl:url];
}

#pragma mark - Init

- (instancetype) initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void) loadImageAndNotify
{
    if(self.image) {
        [self postCompleteNotification];
        return;
    }
    if(self.loadingInProgress) {
        return;
    }
    [self performLoadImageAndNotify];
    
}


- (void) cancelLoading {
    if (_webImageOperation) {
        [_webImageOperation cancel];
        self.loadingInProgress = NO;
    }
}

- (void) imageLoadingComplete
{
    self.loadingInProgress = NO;
    [self performSelector:@selector(postCompleteNotification)
               withObject:nil
               afterDelay:0];
    
}

- (void) postCompleteNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:DOPURLPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

- (void) performLoadImageAndNotify
{
    if (!self.url) {
        return;
    }
    self.loadingInProgress = YES;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    _webImageOperation =
    [manager downloadWithURL:self.url
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        if (expectedSize > 0 ) {
                            float progress = receivedSize / (float) expectedSize;
                            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:progress], @"progress", self, @"photo", nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:DOPURLPHOTO_PROGRESS_NOTIFICATION
                                                                                object:dict];
                        }
                    }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       if (error) {
                           NSLog(@"There is an error occurred when downloading image for url (%@) with error (%@)", self.url, error);
                       }
                       NSLog(@"load completed");
                       _webImageOperation = nil;
                       self.image = image;
                       [self imageLoadingComplete];
                       
                   }];
    
}

@end
