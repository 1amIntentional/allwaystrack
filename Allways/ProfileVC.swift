//
//  SecondViewController.swift
//  Allways
//
//  Created by Jairo Batista on 9/29/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import UIKit

public class ProfileVC: UIViewController {
    
    @IBOutlet weak var numberButton: UIButton!
    
    override public func viewDidLoad() {
        navigationItem.title = "Profile"
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        self.displayPhone()
    }
    
    // Display Saved Phone
    func displayPhone() {
        let phoneInstance = PhoneManager.sharedInstance
        if phoneInstance.get() != nil {
            numberButton.setTitle(phoneInstance.get()!, for: .normal)
        } else {
            numberButton.setTitle("N/A", for: .normal)
        }
    }
}

