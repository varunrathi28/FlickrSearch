//
//  FlickerImageCell.swift
//  Search-Image
//
//  Created by Varun Rathi on 28/06/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

class FlickerImageCell: UICollectionViewCell {
    
    @IBOutlet weak var flickrImage:UIImageView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    
    class var reuseIdentifier: String {
            return String(describing:FlickerImageCell.self)
    }
    
    
    func configureImage(with model:FlickrPhotoModel?){
        
        activityIndicator.startAnimating()
        if let model = model {
            self.activityIndicator.isHidden = false
            FlickerAPI.fetchPhoto(from: model) { (image, error) in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                guard let image = image else {
                    return
                }
                
                self.flickrImage.image = image
                
            }
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicator.isHidden = true
        flickrImage.image = nil
    }
    
}
