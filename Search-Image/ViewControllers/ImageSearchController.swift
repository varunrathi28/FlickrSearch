//
//  ImageSearchController.swift
//  Search-Image
//
//  Created by Varun Rathi on 28/06/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

class ImageSearchController: UIViewController {


    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var textfield:UITextField!
    @IBOutlet weak var btnSearch:UIButton!
    
    var datasource:[AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButtonClicked(with sender:UIButton){
        
        guard let text  = textfield.text else {
            return
        }
        
        // Hit API Here
        
    }
    
}

extension ImageSearchController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

}


