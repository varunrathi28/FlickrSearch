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

        // Checking if the same image is already being downloaded
        
        if let pendingOperation = (imageDownloadQueue.operations as? [ImageDownloadTask])?.filter({ $0.isFinished == false && $0.isExecuting == true && $0.imageUrl.absoluteString == photo.imagePath
        }).first {
            pendingOperation.queuePriority = .veryHigh
            return pendingOperation
            
        }
        
        // No Pending downloads exists
        // Create a new download task
        
        let operation  = ImageDownloadTask(url: photo.photoURL!, indexPath:indexpath)
        //print("Download operation: \(photo)-\(indexpath?.item)")
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
    
    
    func cancelAllDownloads(){
        imageDownloadQueue.cancelAllOperations()
    }
    
  static func setCachedImage(image:UIImage, for url:String){
        imageCache.setObject(image, forKey: url as NSString)
    }
    

}
