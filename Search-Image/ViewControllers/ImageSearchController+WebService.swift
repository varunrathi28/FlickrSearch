//
//  ImageSearchController+WebService.swift
//  Search-Image
//
//  Created by Varun Rathi on 03/07/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit


extension ImageSearchController {

     func searchPhotos(for query:String,page:Int, isPagination:Bool = false){
        
        guard query.count > 0 else {
            return
        }
        
        lastQuery = query
        
        currentRequest = FlickerAPI.searchPhotosForKeywords(input: query, pageNo: page, completionBlock: { (response, error) in
            
            guard let response  = response else {
                
                print("response incorrect")
                return
            }
            
            self.updateDataSource(with:response.photos)
            self.currentRequest = nil
        })
        
    }

}
