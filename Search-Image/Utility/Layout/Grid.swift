//
//  Grid.swift
//  Search-Image
//
//  Created by Varun Rathi on 02/07/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

struct Grid {
    
    var  columns: Int
    var margins:CGFloat
    
    init(columns : Int, margins:CGFloat) {
    self.columns = columns
    self.margins  = margins
}
    
    func size(for view:UIView, height:CGFloat?,insets:UIEdgeInsets = UIEdgeInsets.zero)->CGSize{
    
        let availableWidth = view.frame.size.width - (insets.left + insets.right)
        let widthPerItem = (availableWidth - (CGFloat(columns - 1)*margins))/CGFloat(columns)
        
        if let _ = height {
            return CGSize(width: widthPerItem, height: height!)
        }else {
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }

}
