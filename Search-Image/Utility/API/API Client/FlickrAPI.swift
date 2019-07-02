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
    class func fetchPhoto(from photoModel:FlickrPhotoModel, completionBlock: @escaping (UIImage?,Error?)->Void)->URLSessionTask?{
        
        guard let url = photoModel.photoURL else {
            return nil
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
        return task
    }


    // Fetch response for search typed text
    
    class func searchPhotosForKeywords(input:String,pageNo: Int, completionBlock:@escaping (PhotoRequestBaseResponse?,Error?)-> Void)->URLSessionTask?{
        
        // TODO:- logic for creating url from query text and page id
      //  let urlStr = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(APIKey.REST_API_KEY)&format=json&nojsoncallback=1&safe_search=1&text=\(input)&page=\(pageNo)"
      

        guard let url = getImageURLFromParameters(query: input, page: pageNo) else {
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
    
    class func getImageURLFromParameters(query: String,page :Int) -> URL? {
        
        var components = URLComponents()
        components.scheme = APIURLParameters.scheme
        components.host = APIURLParameters.host
        components.path = APIURLParameters.path
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: APIURLKeys.SearchMethod, value: APIURLValues.SearchMethod))
        queryItems.append(URLQueryItem(name: APIURLKeys.DisableJSONCallback, value: APIURLValues.DisableJSONCallback))
        queryItems.append(URLQueryItem(name: APIURLKeys.APIKey, value: APIKey.REST_API_KEY))
        queryItems.append(URLQueryItem(name: APIURLKeys.ResponseFormat, value: APIURLValues.ResponseFormat))
        queryItems.append(URLQueryItem(name: APIURLKeys.SafeSearch, value: APIURLValues.SafeSearch))
        queryItems.append(URLQueryItem(name: APIURLKeys.Text, value:query))
        queryItems.append(URLQueryItem(name: APIURLKeys.Extras, value: APIURLValues.MediumURL))
         queryItems.append(URLQueryItem(name: APIURLKeys.Page, value:String(page)))
        
        //Set query params
        components.queryItems = queryItems
        return components.url
    }


}
