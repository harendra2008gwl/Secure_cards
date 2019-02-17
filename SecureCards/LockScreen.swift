//
//  LockScreen.swift
//  SecureCards
//
//  Created by Harendra Sharma on 22/05/17.
//  Copyright © 2017 Harendra Sharma. All rights reserved.
//

import UIKit
import LocalAuthentication


class LockScreen: UIView {
    
    // Hiding lock view so that user can access app. 
    func Hide(){
        self.isHidden = true
    }
    
    // Show lock screen so that unauthorised user cannot access your data
    func Show() {
        self.isHidden = false
        
        // 1. Create a authentication context
        let authenticationContext = LAContext()
        var error:NSError?
        
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
           guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("This device does not have a TouchID sensor.")
            return
        }
        
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Your cards are secured by Biometrics Authentication.",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    DispatchQueue.main.async {
                        self.Hide()
                    }

                    
                    // Fingerprint recognized
                    // Go to view controller
                    
                }else {
                    
                    // Check if there is an error
                    if error != nil {
                        
                      
                    }
                }
        })
    }

    

    
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.Show()
    }
    

    
    @IBAction func clicktoAuth(_ sender: Any) {
        self.Show()
    }
    
    
    
    
    //Mark: Final closer... Do Not Write Code Below This Line.....
}
