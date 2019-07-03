//
//  ImageSearchController+Preheat.swift
//  Search-Image
//
//  Created by Varun Rathi on 03/07/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

extension ImageSearchController {


     func updateCachedAssets() {
    
        return
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The preheat window is twice the height of the visible rect.
        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        
        var addedObjIndexPaths = [IndexPath]()
        var removedObjIndexPaths = [IndexPath]()
        
        for rect in addedRects {
           if  let indexpaths = self.collectionView.indexpaths(for: rect) {
            addedObjIndexPaths.append(contentsOf: indexpaths)
            }
        }
        
        for rect in removedRects {
            if let indexpaths = self.collectionView.indexpaths(for: rect) {
                removedObjIndexPaths.append(contentsOf: indexpaths)
            }
        }
        
        let assetsToStartCaching = assets(at: addedObjIndexPaths)
        let assetsToStopCaching = assets(at: removedObjIndexPaths)
        
        
        // Reduce priority for all views going out of Region
        assetsToStopCaching?.forEach({ ImageDownloader.shared.reduceImageDownloadPriority(for: $0)})
        
        // Start download tasks for all cells comming in Region
        
        assetsToStartCaching?.forEach({ ImageDownloader.shared.downloadImage(for: $0, for: nil, completionHandler: { (_, _, _) -> (Void) in
        })
        })
        
        
        // Update new preheat rect
        self.previousPreheatRect = preheatRect
        
}

  fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                    width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                    width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                      width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                      width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }

    func assets(at indexpaths:[IndexPath]?)->[FlickrPhotoModel]? {
        
        guard let indexpaths = indexpaths else {
            return nil
        }
        let objects = indexpaths.map { indexpath  in
            datasource[indexpath.item]
        }
        
        return objects
    }

    }
    

