//
//  ImageSearchController+.swift
//  Search-Image
//
//  Created by Varun Rathi on 03/07/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

//MARK: CollectionView Methods

extension ImageSearchController:UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:FlickerImageCell.reuseIdentifier, for: indexPath) as! FlickerImageCell
        let model = datasource[indexPath.row]
        cell.configureImage(with: model,for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        let width =  (UIScreen.main.bounds.size.width)/3 - 8
    //        return CGSize(width: width , height: width)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let prefetchingRange = datasource.count - PAGINATION_OFFSET
        
        if prefetchingRange > 0 &&  (prefetchingRange ... datasource.count - 1) ~= indexPath.row{
            
            if let lastQuery = lastQuery, currentRequest == nil, PAGE_NO < total_pages  {
                
                searchPhotos(for: lastQuery, page:PAGE_NO + 1)
            }
            
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
}

}


extension ImageSearchController: UICollectionViewDataSourcePrefetching {

     func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetching : \(indexPaths)")
    }
}

