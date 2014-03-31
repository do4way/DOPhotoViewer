Pod::Spec.new do |s|

  s.name         = "DOPhotoViewer"
  s.version      = "0.0.1"
  s.summary      = "An photo slider viewer for ios application. "

  s.description  = <<-DESC
                   The library provides a slider view for photos online.

                   * The viewer hanles the downloading and caching of photos from the web, and display them with page controller.
                     User can browse the photos by flip forward and backward. Photos can be zoomed, panned and rotated according
                     device orientation.
                   DESC

  s.homepage     = "https://github.com/do4way/DOPhotoViewer"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"

  s.license      = "MIT"
  s.author             = { "Yongwei" => "yongwei.dou@gmail.com" }

  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/do4way/DOPhotoViewer.git", :tag => "v0.0.1" }

  s.source_files  = "DOPhotoViewer", "DOPhotoViewer/**/*.{h,m}"
  s.exclude_files = "DOPhotoViewer/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  s.requires_arc = true

  s.dependency "DACircularProgress", "~> 2.1.0"
  s.dependency "SDWebImage",         "~> 3.6"

end
