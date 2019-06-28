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
    var currentPage = 1
    var datasource:[FlickrPhotoModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    
    func setUpViews(){
        setupCollectionView()
        registerNib()
    
    }
    
    func setupCollectionView(){
    
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
        guard let query  = textfield.text else {
            return
        }
        
        
        // If already requests are going on, cancel them all
        if (currentRequest != nil){
            currentRequest?.cancel()
        }
    
        //collectionView.reloadData()
        searchPhotos(for: query)
        
    }
    
    func searchPhotos(for query:String){
        
        guard query.count > 0 else {
            return
        }
        
        currentRequest = FlickerAPI.searchPhotosForKeywords(input: query, pageNo: currentPage, completionBlock: { (response, error) in
            
            guard let response  = response else {
                
                print("response incorrect")
                return
            }
            
            if self.currentPage == 1 {
                self.datasource.removeAll()
            }
            
            self.updateDataSource(models: response.photos.photo)
        })
        
    }
    
    func updateDataSource(models:[FlickrPhotoModel]) {
    
        datasource.append(contentsOf: models)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
    
        let width =  (UIScreen.main.bounds.size.width)/3 - 10
        return CGSize(width: width , height: width)
    }
}


extension ImageSearchController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    
        if let text = textField.text, let range = Range(range, in: text) {
            let fullText = text.replacingCharacters(in: range, with: string)
            
            if fullText.count > 0 {
                    searchPhotos(for: fullText)
            }
        }
    
        return true
    }
    
}

