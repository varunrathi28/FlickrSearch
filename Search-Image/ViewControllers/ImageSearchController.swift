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
    
    let GRID_PER_LINE = 3
    let margin:CGFloat  = 16.0
    
    
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
        
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let grid = Grid(columns: GRID_PER_LINE, margins: margin)
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionViewLayout?.minimumInteritemSpacing = margin
        collectionViewLayout?.minimumLineSpacing = margin
        
         collectionViewLayout?.itemSize = grid.size(for: view, height: nil,insets:(collectionViewLayout?.sectionInset)!)
        
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
    
}

