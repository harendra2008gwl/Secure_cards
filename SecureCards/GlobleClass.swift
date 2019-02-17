//
//  GlobleClass.swift
//  SecureCards
//
//  Created by Harendra Sharma on 21/05/17.
//  Copyright © 2017 Harendra Sharma. All rights reserved.
//

import UIKit

// This class helps to access globle methods for code reusability

class GlobleClass: NSObject {
    
    // Show alert from any UIViewController, we can also customise it as pr our use.
    func ShowAlert(ViewControllder: UIViewController, title: String, message: String) -> Void {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        (ViewControllder as AnyObject).present(alert, animated: true, completion: nil)
    }
    
    
    
// Mark: Group Text field charecters i.e. credit card number 1111-2222-3333-4444 or Exp date: 08/22. For this add your textfield delegate and in the "shouldChangeCharactersIn" delegate method pass that textfield,and parameters.
    
    func GroupTextField(textField: UITextField, range: NSRange, string: String, maxLength: NSInteger, group:NSInteger, seperater: String) -> Bool {
        
        
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
        }
        else
        {
            let strCount = String(textField.text!.count + 1)
            
            if Int(strCount)! % (group+1) == 0 && Int(strCount)! > 1 && Int(strCount)! < maxLength+(group-1) {
                textField.text = textField.text! + seperater
            }
            
            guard let text = textField.text else
            {
                return true
            }
            let newLength = text.count + string.count - range.length
            return newLength <= maxLength+(group-1)
        }
        return true
    }
 
    
 //Mark: Final closer... Do Not Write Code Below This Line.....
}
