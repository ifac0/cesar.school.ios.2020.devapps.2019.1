//
//  CarViewController.swift
//  Carangas
//
//  Copyright © 2020 Ivan Costa. All rights reserved.
//

import UIKit
import WebKit

class CarViewController: UIViewController {

    
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var wkImages: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    var car: Car!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        title = car.name
        lbBrand.text = car.brand
        lbGasType.text = car.gas
        lbPrice.text = "\(car.price)"
        
        let name = (car.name + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.google.com.br/search?q=\(name)&tbm=isch"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        wkImages.allowsBackForwardNavigationGestures = true
        wkImages.allowsLinkPreview = true
        wkImages.navigationDelegate = self
        wkImages.uiDelegate = self
        wkImages.load(request)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AddEditViewController
        vc?.car = car
    }

}


extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("stopLoading")
        loading.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loading.stopAnimating()
    }
}
