//
//  EditProfileVC.swift
//  Allways
//
//  Created by Jairo Batista on 11/1/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import UIKit

public class EditProfileVC: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // Hide Number Pad When User Touches Outside Of It
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Submit New Phone Number
    @IBAction func submitNewPhoneNumber(_ sender: AnyObject) {
        if let newNumber = phoneNumberTextField.text , newNumber != "", Int64(newNumber) != nil {
            self.saveNewPhoneNumber(newNumber: newNumber)
            let _ = navigationController?.popViewController(animated: true)
        } else {
            // TODO: Alert User That Submitted Data Not Valid, Try Again
        }
    }
    
    // Save New Phone Number
    func saveNewPhoneNumber(newNumber: String) {
        // Instantiate Phone Number Manager
        let phone = PhoneManager.sharedInstance
        phone.set(number: newNumber)
        phone.save()
    }
}
