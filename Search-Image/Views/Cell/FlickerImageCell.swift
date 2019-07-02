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
    var currentReqest:ImageDownloadTask?
    
    
    class var reuseIdentifier: String {
            return String(describing:FlickerImageCell.self)
    }
    
    
    func configureImage(with model:FlickrPhotoModel?,for indexpath:IndexPath){
        currentReqest?.cancel()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        if let model = model {
            
            DispatchQueue.global().async {
                
                self.currentReqest = ImageDownloader.shared.downloadImage(for: model,for: indexpath,  completionHandler: {[weak self] (downloadedImage, url, indexpathh) -> (Void) in
                    withExtendedLifetime(self) {
                        self!.activityIndicator.isHidden = true
                        self!.activityIndicator.stopAnimating()
                        
                        if let image = downloadedImage,indexpathh == indexpath  {
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
