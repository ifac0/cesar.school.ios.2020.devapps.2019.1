//
//  ViewController.swift
//  FirebaseDemo2
//
//  Created by Douglas Frari on 30/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
    }


}

