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
        return NSStringFromClass(FlickerImageCell.self)
    }
    
    
    
}
