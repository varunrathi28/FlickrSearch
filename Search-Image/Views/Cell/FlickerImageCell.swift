//
//  FlickerImageCell.swift
//  Search-Image
//
//  Created by Varun Rathi on 28/06/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

class FlickerImageCell: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var flickrImage:UIImageView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    //MARK: variables
    var currentReqest:URLSessionTask?
    
    
    class var reuseIdentifier: String {
            return String(describing:FlickerImageCell.self)
    }
    
    
    func configureImage(with model:FlickrPhotoModel?){
        currentReqest?.cancel()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        if let model = model {
            
            // Use the cached image
            
            DispatchQueue.global().async {
                
                self.currentReqest = ImageDownloader.downloadImage(for: model, completionHandler: {[weak self] (downloadedImage) -> (Void) in
                    
                    withExtendedLifetime(self) {
                        self!.currentReqest = nil
                        self!.activityIndicator.isHidden = true
                        self!.activityIndicator.stopAnimating()
                        
                        if let image = downloadedImage {
                            self!.flickrImage.image = image
                        }
                    }
                })
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicator.isHidden = true
        flickrImage.image = nil
        currentReqest?.cancel()
    }
    
}
