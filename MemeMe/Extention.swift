//
//  Extention.swift
//  MemeMe
//
//  Created by Runa Alam on 6/9/18.
//  Copyright © 2018 Runa Alam. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func attributedTextField(placeHolder: String){
       
         // Set defaultTextAttributes property for custom font
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3.0]
        
        let placHolderAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.strokeColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "Impact", size: 40)!, NSAttributedStringKey.strokeWidth: -3.0]
        
        self.defaultTextAttributes = memeTextAttributes
        self.borderStyle = .none
        self.textAlignment = .center
        self.autocapitalizationType = .allCharacters
        self.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: placHolderAttributes)
    }
}

