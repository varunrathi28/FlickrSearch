//
//  ImageSearchController.swift
//  Search-Image
//
//  Created by Varun Rathi on 28/06/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

class ImageSearchController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var textfield:UITextField!
    @IBOutlet weak var btnSearch:UIButton!
    
    
    
    //MARK: Variables
    
    var currentRequest:URLSessionTask?
    var PAGE_NO = 1
    var PAGINATION_OFFSET = 30
    var datasource:[FlickrPhotoModel] = []
    var lastQuery:String?
    var total_pages = 2
    
    //MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    
    func setUpViews(){
        setupCollectionView()
        registerNib()
        
    }
    
    func setupCollectionView(){
        
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        textfield.delegate = self
    }
    
    func registerNib(){
        let cellNib = UINib.init(nibName:"FlickrImageCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier:FlickerImageCell.reuseIdentifier)
    }
    
    
    @IBAction func searchButtonClicked(with sender:UIButton){
        
        // If no input-> return
        guard let query  = textfield.text, textfield.text != lastQuery else {
            return
        }
        
        
        // If already requests are going on, cancel them alll
        currentRequest?.cancel()
        datasource = []
        
        PAGE_NO = 1
        searchPhotos(for: query,page:PAGE_NO)
        
    }
    
    func searchPhotos(for query:String,page:Int, isPagination:Bool = false){
        
        guard query.count > 0 else {
            return
        }
        
        lastQuery = query
        
        currentRequest = FlickerAPI.searchPhotosForKeywords(input: query, pageNo: page, completionBlock: { (response, error) in
            
            guard let response  = response else {
                
                print("response incorrect")
                return
            }
            
            self.updateDataSource(with:response.photos)
            self.currentRequest = nil
        })
        
    }
    
    func updateDataSource(with response:PhotoReqestResponse?) {
        
        
        guard let photoResponse = response else {
            return
        }
        // Update current page
        PAGE_NO = photoResponse.page
        total_pages = photoResponse.pages
        
        let photos = photoResponse.photo
        
        if photoResponse.page > 1{
            
            let datasourceCount = datasource.count
            let indexPathsToUpdate = photos.enumerated().map { (offset,photoModel) -> IndexPath in
                IndexPath(item: datasourceCount + offset, section: 0)
            }
            
            
            
            DispatchQueue.main.async {
                self.datasource.append(contentsOf: photos)
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: indexPathsToUpdate)
                    
                }, completion: nil)
            }
            
        } else {
            datasource = photos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    func prefetchImages(for indexes:[IndexPath]){
    
    }
    
    
}

//MARK: CollectionView Methods

extension ImageSearchController:UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:FlickerImageCell.reuseIdentifier, for: indexPath) as! FlickerImageCell
        let model = datasource[indexPath.row]
        cell.configureImage(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width =  (UIScreen.main.bounds.size.width)/3 - 8
        return CGSize(width: width , height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let prefetchingRange = datasource.count - PAGINATION_OFFSET
    
        if  (prefetchingRange ... datasource.count - 1) ~= indexPath.row{
            
            if let lastQuery = lastQuery, currentRequest == nil, PAGE_NO < total_pages  {
            
                searchPhotos(for: lastQuery, page:PAGE_NO + 1)
            }
            
        }
}
    
    
}

extension ImageSearchController: UICollectionViewDataSourcePrefetching {

     func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetching : \(indexPaths)")
    }
}


extension ImageSearchController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    
        if let text = textField.text, let range = Range(range, in: text) {
            let fullText = text.replacingCharacters(in: range, with: string)
            
            if fullText.count > 2 && fullText != lastQuery && currentRequest == nil {
                    PAGE_NO = 1
                    searchPhotos(for: fullText, page:PAGE_NO)
            }
        }
    
        return true
    }
    
}

