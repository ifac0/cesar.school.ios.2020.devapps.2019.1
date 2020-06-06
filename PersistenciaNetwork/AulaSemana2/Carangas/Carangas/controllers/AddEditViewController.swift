//
//  AddEditViewController.swift
//  Carangas
//
//  Copyright © 2020 Ivan Costa. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    var car: Car!
    var brands: [Brand] = []
    
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    } ()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if car != nil{
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("update:", for: .normal)
        }
        
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancel, btSpace, btDone]
        tfBrand.inputAccessoryView = toolbar
        tfBrand.inputView = pickerView
        
        loadBrands()
    }
    

    @objc func cancel() {
        tfBrand.resignFirstResponder()
    }
    
    @objc func done() {
        tfBrand.text = brands[pickerView.selectedRow(inComponent: 0)].fipe_name
        cancel()
    }
    
    
    func loadBrands() {
        startLoadingAnimation()
        RestAlamofire.loadBrands { (brands) in
            DispatchQueue.main.async {
                self.stopLoadingAnimation()
            }
            guard let brands = brands else {
                self.showAlert(withTitle: "Marcas carros", withMessage: "Erro ao pegar marcas de carros", isTryAgain: true, operation: .get_brands)
                return
            }
            self.brands = brands.sorted(by: {$0.fipe_name < $1.fipe_name})
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
                self.stopLoadingAnimation()
            }
        }
    }
    
    
    @IBAction func addEdit(_ sender: UIButton) {
        if car == nil {
            car = Car()
        }
        
        car.name = (tfName?.text)!
        car.brand = (tfBrand?.text)!
        if tfPrice.text!.isEmpty {
            tfPrice.text = "0"
        }
        car.price = Double(tfPrice.text!)!
        car.gasType = scGasType.selectedSegmentIndex
        
        
        if car._id == nil {
            saveCar()
        } else {
           editCar()
        }
    }
    
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func startLoadingAnimation() {
        self.btAddEdit.isEnabled = false
        self.btAddEdit.backgroundColor = .gray
        self.btAddEdit.alpha = 0.5
        self.loading.startAnimating()
    }
    
    
    func stopLoadingAnimation() {
        self.btAddEdit.isEnabled = true
        self.btAddEdit.backgroundColor = UIColor(named: "main")
        self.btAddEdit.alpha = 1
        self.loading.stopAnimating()
    }
    
    
    func saveCar(){
        startLoadingAnimation()
        RestAlamofire.save(car: car) { (success) in
            DispatchQueue.main.async {
                self.stopLoadingAnimation()
                if (success){
                    self.goBack()
                }else{
                    self.showAlert(withTitle: "Save", withMessage: "Não foi possivel salvar agora, tente novamente.", isTryAgain: true, operation: .add_car)
                }
            }
        }
    }
    
    
    func editCar(){
       startLoadingAnimation()
       RestAlamofire.update(car: car) { (success) in
          DispatchQueue.main.async {
            self.stopLoadingAnimation()
              if(success){
                 self.goBack()
              }else{
                 self.showAlert(withTitle: "Update", withMessage: "Não foi possivel atualizar agora, tente novamente.", isTryAgain: true, operation: .edit_car)
             }
          }
       }
    }
    
    
    func showAlert(withTitle titleMessage: String, withMessage message: String, isTryAgain hasRetry: Bool, operation oper: CarOperationAction) {
        
        if oper != .get_brands {
            DispatchQueue.main.async {
                // ?
            }
        }
        
        let alert = UIAlertController(title: titleMessage, message: message, preferredStyle: .actionSheet)
        if hasRetry {
            let tryAgainAction = UIAlertAction(title: "Tentar novamente", style: .default, handler: {(action: UIAlertAction) in
                
                switch oper {
                case .add_car:
                   self.saveCar()
                case .edit_car:
                    self.editCar()
                case .get_brands:
                    self.loadBrands()
                }
                
            })
            alert.addAction(tryAgainAction)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(action: UIAlertAction) in
                self.goBack()
            })
            alert.addAction(cancelAction)
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}



extension AddEditViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let brand = brands[row]
        return brand.fipe_name
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
}


enum CarOperationAction {
    case add_car
    case edit_car
    case get_brands
}
