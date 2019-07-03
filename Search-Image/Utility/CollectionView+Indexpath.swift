//
//  CollectionView+Indexpath.swift
//  Search-Image
//
//  Created by Varun Rathi on 03/07/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit


extension UICollectionView {
    
    func indexpaths(for region:CGRect)->[IndexPath]?
    {
        var indexpaths = [IndexPath]()
        
        if  let layoutAttributeArray = self.collectionViewLayout.layoutAttributesForElements(in: region){
            
            for layoutAttribute in layoutAttributeArray {
                indexpaths.append(layoutAttribute.indexPath)
            }
        }
        
        return indexpaths
    }
    
}
