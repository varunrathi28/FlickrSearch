//
//  FlickrPhotoModel.swift
//  Search-Image
//
//  Created by Varun Rathi on 28/06/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import Foundation

//MARK: Base Model

struct PhotoRequestBaseResponse : Codable
{
    
    let stat           :String
    let photos         :PhotoReqestResponse
}



// Mark: Photo Batch Response
struct PhotoReqestResponse:Codable
{
    let photo         :[FlickrPhotoModel]
    let page          :Int
    let pages         :Int
    let perpage       :Int
    let total         :String
}


//MARK:-Single Photo Model
struct FlickrPhotoModel : Codable
{
    let id              :String
    let owner           :String
    let secret           :String
    let server           :String
    let title            :String
    let farm             :Int
    let ispublic          :Int
    let isfriend          :Int
    let isfamily          :Int
    
    
    //MARK: URL Getter
    var imagePath:String {
       return  "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
    var photoURL :URL?{
        if let url = URL(string:imagePath){
            return url
        }
        return nil
    }
}
