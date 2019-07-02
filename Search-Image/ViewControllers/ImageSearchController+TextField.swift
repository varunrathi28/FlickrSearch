//
//  ImageSearchController+TextField.swift
//  Search-Image
//
//  Created by Varun Rathi on 03/07/19.
//  Copyright © 2019 Varun Rathi. All rights reserved.
//

import UIKit

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

