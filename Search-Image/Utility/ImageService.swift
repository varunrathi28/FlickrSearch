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
    
    static func downloadImage(for photo:FlickrPhotoModel, completionHandler:@escaping (UIImage?)->(Void)) -> URLSessionTask? {
        
        if let cachedImage =  fetchImageFromCache(for: photo.imagePath){
            
            DispatchQueue.main.async {
                completionHandler(cachedImage)
            }
            return nil
        }
        
        let task = FlickerAPI.fetchPhoto(from: photo) { (image, error) in
            
            if let image  = image {
                
                setCachedImage(image: image, for: photo.imagePath)
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            }else {
                
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
            
        }
        
        return task
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
