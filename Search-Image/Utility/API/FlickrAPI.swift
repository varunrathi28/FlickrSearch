//
//  FlickrAPI.swift
//  Search-Image
//
//  Created by Varun Rathi on 28/06/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

class FlickerAPI{


    // To fetch singe photo
    class func fetchPhoto(from photoModel:FlickrPhotoModel, completionBlock: @escaping (UIImage?,Error?)->Void){
        
        guard let url = photoModel.photoURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                
                DispatchQueue.main.async {
                    completionBlock(nil,error)
                }
                return
            }
            
            if  let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completionBlock(image,nil)
                }
            }else {
               DispatchQueue.main.async {
                    completionBlock(nil,error)
                }
            }
        }
        task.resume()
    }


    // Fetch response for search typed text
    
    class func searchPhotosForKeywords(input:String,pageNo: Int, completionBlock:@escaping (PhotoRequestBaseResponse?,Error?)-> Void)->URLSessionTask?{
        
        let urlStr = ""
        
        guard let url = URL(string: urlStr) else {
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Check if valid data is received else return
            guard let data  = data else {
                DispatchQueue.main.async {
                    completionBlock(nil,error) // Invalid data
                }
                return
            }
            
            // Valid data received -> Serialize
            
            let decoder = JSONDecoder()
            
            do {
                let responseData = try decoder.decode(PhotoRequestBaseResponse.self, from: data)
                completionBlock(responseData,nil)
            }
            catch{
                completionBlock(nil,error)
            }
            
        }
        
        task.resume()
        return task
    }


}
