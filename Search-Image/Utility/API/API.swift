//
//  API.swift
//  Search-Image
//
//  Created by Varun Rathi on 28/06/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import Foundation


public struct APIKey {
   static  let REST_API_KEY = "3e7cc266ae2b0e0d78e279ce8e361736"
}


public struct APIURLParameters{

    static let scheme =     "https"
    static let host =       "api.flickr.com"
    static let path =       "/services/rest"
}

struct APIURLKeys {
    
    static let SearchMethod = "method"
    static let APIKey = "api_key"
    static let Extras = "extras"
    static let ResponseFormat = "format"
    static let DisableJSONCallback = "nojsoncallback"
    static let SafeSearch = "safe_search"
    static let Text = "text"
    static let Page = "page"
}


public struct APIURLValues {
static let SearchMethod = "flickr.photos.search"
static let ResponseFormat = "json"
static let DisableJSONCallback = "1"
static let MediumURL = "url_m"
static let SafeSearch = "1"
}
