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


  

}
