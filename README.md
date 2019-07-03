# FlickrSearch

# Flickr Search
iOS App for searching images using Flickr API. Type the query on the search bar, the resupts are automatically populated.

    Features :-
    1. Paging & Infinite Scrolling.
    2. Caching of images
    3. Managing download priorities
    4. Automatic search on text change
    5. Preheating images with region.
    6. Custom Operations for Image downloads.
  

# Paging & Infinite Scrolling
Image search results are indexed by page numbers. When we do a new search, the results starts from Page = 1. As we scroll down, the pagination is done and further requests are hit by incrementing the Page numbers.

# Caching
For saving the user netowork data, images are cached once downloaded. The mapping is done with <String, UIImage> with url of the image being the key. The cache size is 20 Mb, which can be configured and maximum pages  is kept at 200.

```sh
  static var imageCache :NSCache<NSString, UIImage> {
        let cache = NSCache<NSString,UIImage>()
        // Cache of 20 MB
        cache.totalCostLimit = 20*1024*1024
        cache.countLimit = 200
        return cache
    }
    
    //get
    func fetchImageFromCache(for url:String)->UIImage?{
        if let image = imageCache.object(forKey: url as NSString){
            print("Cached:\(url)")
            return image
        }
        return nil
    }
    
    //set 
     func setCachedImage(image:UIImage, for url:String){
        imageCache.setObject(image, forKey: url as NSString)
    }
```    

# Preheating
Preheating is a concept used for fetching data ahead of time in tableviews and collections.
 Since images are displayed in a scrollview, we can have a prefetching region (like twice the screen size). As the user scrolls, we can update the region, with new Rect  and calculating the indexes of the items which would be included in the update preheat rect , and removedItems which would be exluded. We can schedule parallel Async tasks for fetching images in advance. This would result in improved user experience.
 
 ```sh
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
 ```
# Managing download priorities
All image downloads are encapsulated inside a Custom NSOperation Subclass and added on the operation queue.
The indexpaths that will be shown, due to prefetching/ preheating, async downloads would be inititated for them. If any pending unfinished download for any specific task already exists, then we increase the queuePriority. 

Similary, for indexpaths, going out of scrolling direction, we would decrease the priority like :.
####  A) Decreasing priority
```sh

  func reduceImageDownloadPriority(for photo:FlickrPhotoModel) {
        if let  pendingOperation = (imageDownloadQueue.operations as! [ImageDownloadTask]).filter({ $0.isExecuting == true && $0.isFinished == false && $0.imageUrl.absoluteString == photo.imagePath
        }).first {
            pendingOperation.queuePriority = .low
        }
    }
```

#### B.) Increasing priority
```sh
 // Checking if the same image is already being downloaded
        
        if let pendingOperation = (imageDownloadQueue.operations as? [ImageDownloadTask])?.filter({ $0.isFinished == false && $0.isExecuting == true && $0.imageUrl.absoluteString == photo.imagePath
        }).first {
            pendingOperation.queuePriority = .veryHigh
            return pendingOperation
}
```

# Overview:
    ImageSearchController : The main view controller.
    FlickrAPI: API Client and URL, Query Builder
    ImageDownloadTask: Subclass of `Operation` for download image
    ImageDownloader:- Class for managing queuing of download tasks and caching the images.
    FlickrPhotoModel: all the models 

# Future Considerations:-
- MVVM Design: decoupling model from the view controller and binding the controller to the data changes from API.
- Test Cases
- PipeLining of Operation Queues:- For better optimization, we can pipeline multiple queues for specific tasks, Caching, parsing,Downloading etc. Every queue can have different Priority concurrency.
- PagingModel embedded in ViewModel
