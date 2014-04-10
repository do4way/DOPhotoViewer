DOPhotoViewer
=============

An photo slider viewer for ios application. 

Features
------------------------------------

+ Simple viewer of photos, which will be download via URLs and caching it.
Thanks SDWebImage and DACircularProgress

+ Double tap to enlarge the photo.

+ Flip with the photo to view them one by one

+ Photo will be automate fill with screen, when the device is roted

Run the demo application

+ First you should run pod install to retrieve dependency libraries and create a default workspace for you.

+ In the workspace pod created, you will find a static library project and pod project.

+ In finder, just drag the DOPhotoView DEMO project into your workspace

+ Select the demo project , compile and run it.


Use the library
------------------------------------

+ With pod, you can just add as following
<
  pod 'DOPhotoViewer', :git=>'https://github.com/do4way/DOPhotoViewer.git'
>

+ Or add the source file to your project, pay attention include the dependency libraries: SDWebImage, DACircularProgress

DOPhotoView Interface
-----------------------------------

--- ViewController
---- DOPSliderPhotoViewerViewController
This is a main view controller of DOPPhotoViewer, you can just add it to a storyboard, or create a sub-class of it.
Anyway you should set the dataSourceDelegate:DOPhotoViewDataSource and delegate:DOPhotoViewDelegate

--- Protocol
protocols defined in the header file DOPhotoViewerProtocols.h

---- DOPhotoViewDataSource
the datasource provider. To implement the protocol you should implementation the following methods

----- Required method
* (NSUInteger) numberOfPhotos;
the method return the number you need to browse.
* (NSURL *)    photoUrlAtIndex:(NSUInteger) idx;
the method return the url in the index specified
----- Optional method
*  (NSUInteger) startAtPage;
the method return the page index of start to browse. If you do not implement this method, it will start at page 0.

---- DOPhotoViewerDelegate
The delegate just define a method which will be invoked when user single tap on the viewer.
----- Required Method
* (void) tapToExit
Method is prepared for add some custom segue action with a single tap.



 
