//
//  Tela1ViewController.swift
//  CocoaPodTests
//
//  Created by Douglas Frari on 30/05/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit
import Alamofire

class Tela1ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sample Alamofire"
        self.navigationItem.largeTitleDisplayMode = .always

        AF.request("https://carangas.herokuapp.com/cars").responseJSON { response in
             debugPrint("Response: \(response)")
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
