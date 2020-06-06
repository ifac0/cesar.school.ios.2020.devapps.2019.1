//
//  CarsTableViewController.swift
//  Carangas
//
//  Copyright © 2020 Ivan Costa. All rights reserved.
//

import UIKit
import SideMenu


class CarsTableViewController: UITableViewController {

    
    var cars: [Car] = []
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.loading.startAnimating()
        loadData()
    }
    

   @objc func loadData(){
        RestAlamofire.loadCars(onComplete: { (cars) in
            self.cars = cars
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                self.loading.stopAnimating()
            }
            
        }) { (error) in
            DispatchQueue.main.async {
                self.loading.stopAnimating()
            }
            
            var response: String = ""
            switch error {
            case .invalidJSON:
                response = "invalid"
            case .noData:
                response = "null"
            case .noResponse:
                response = "no-response"
            case .url:
                response = "file-invalid"
            case .taskError(let error):
                response = "\(error.localizedDescription)"
            case .responseStatusCode(let code):
                if code != 200 {
                    response = "Error. :( \nError:\(code)"
                }
            }
            print(response)
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let car = cars[indexPath.row]
            RestAlamofire.delete(car: car) { (success) in
                if success {
                    self.cars.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil{
            if segue.identifier! == "viewSegue" {
                let vc = segue.destination as! CarViewController
                vc.car = cars[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}
