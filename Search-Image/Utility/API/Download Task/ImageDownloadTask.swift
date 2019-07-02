//
//  ImageDownloadTask.swift
//  Search-Image
//
//  Created by Varun Rathi on 03/07/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

typealias ImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

class ImageDownloadTask: Operation {
    
    private var indexPath: IndexPath?
    var completionHandler: ImageDownloadHandler?
    var imageUrl: URL!
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet{
            didChangeValue(forKey: "isFinished")
        }
        
    }
    
    override var isFinished: Bool {
        
        return _finished
    }
    
    
    required init (url: URL, indexPath: IndexPath?) {
        self.imageUrl = url
        self.indexPath = indexPath
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    override func main() {
        
        guard isCancelled == false else {
            return
        }
        
        executing(true)
        downloadImageFromUrl()
    }
    
    func downloadImageFromUrl() {
        let newSession = URLSession.shared
        let downloadTask = newSession.downloadTask(with: self.imageUrl) { (location, response, error) in
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                let image = UIImage(data: data)
                self.completionHandler?(image,self.imageUrl,self.indexPath,error)
            }
            self.finish(true)
            self.executing(false)
        }
        downloadTask.resume()
    }
    
}
