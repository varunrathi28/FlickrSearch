//
//  ImageService.swift
//  Search-Image
//
//  Created by Varun Rathi on 30/06/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

class ImageDownloader {

    static let imageCache = NSCache<NSString, UIImage>()

    lazy var imageDownloadQueue:OperationQueue = {
    
    let queue = OperationQueue()
    queue.name = "com.search-image.imagedownload"
    queue.qualityOfService  = .userInteractive
    return queue
    }()

    static let shared = ImageDownloader()
    private init() {}
    
    
     func downloadImage(for photo:FlickrPhotoModel,for indexpath:IndexPath? , completionHandler:@escaping (UIImage?,URL,IndexPath?)->(Void)) -> ImageDownloadTask? {
        
        guard let _ = photo.photoURL else {
            return nil
        }
        
        if let cachedImage = ImageDownloader.fetchImageFromCache(for: photo.imagePath){
            
            DispatchQueue.main.async {
                completionHandler(cachedImage,photo.photoURL!,indexpath)
            }
            return nil
        }
        
//        let task = FlickerAPI.fetchPhoto(from: photo) { (image, error) in
//
//            if let image  = image {
//
//                setCachedImage(image: image, for: photo.imagePath)
//                DispatchQueue.main.async {
//                    completionHandler(image)
//                }
//            }else {
//
//                DispatchQueue.main.async {
//                    completionHandler(nil)
//                }
//            }
//
//        }

        let operation  = ImageDownloadTask(url: photo.photoURL!, indexPath:indexpath)
        print("Download operation: \(photo)-\(indexpath?.item)")
        operation.queuePriority = .veryHigh

        operation.completionHandler = {(image, url,newIndexpath,error) in
            
            if let image = image {
                ImageDownloader.setCachedImage(image: image, for: url.absoluteString)
            }
            
            DispatchQueue.main.async {
                completionHandler(image,url,newIndexpath)
            }
            
        }
        
        imageDownloadQueue.addOperation(operation)
        return operation
    }
    
      static  func fetchImageFromCache(for url:String)->UIImage?{
        if let image = imageCache.object(forKey: url as NSString){
            print("Cached:\(url)")
            return image
        }
        return nil
    }
    
  static func setCachedImage(image:UIImage, for url:String){
        imageCache.setObject(image, forKey: url as NSString)
    }
    

}
