//
//  ConsoleViewController.swift
//  MyGame
//
//  Created by Ivan Costa on 28/05/20.
//

import UIKit
import Photos

class ConsoleViewController: UIViewController {
   
    @IBOutlet weak var lbNameConsole: UITextField!
    @IBOutlet weak var ivCoverConsole: UIImageView!
    @IBOutlet weak var btConsole: UIButton!
    @IBOutlet weak var buttonCoverConsole: UIButton!
    
    var consolesManager = ConsolesManager.shared
    var myConsole: Console!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myConsole == nil{
            title = "Cadastrar"
            btConsole.setTitle("Cadastrar", for: .normal)
        } else {
            
            title = "Editar"
            btConsole.setTitle("Editar", for: .normal)
            lbNameConsole.text = myConsole.name
            
            ivCoverConsole.image = myConsole.coverConsole as? UIImage
            if myConsole.coverConsole != nil {
                buttonCoverConsole.setTitle(nil, for: .normal)
            }
        }
    }
    
    @IBAction func btInsertEdit(_ sender: UIButton) {
        
        if myConsole == nil{
            insertConsole(with: nil)
        } else {
            updateConsole()
        }
    }

    func insertConsole(with console: Console?){
        
        let console = console ?? Console(context: self.context)
            console.name = lbNameConsole?.text
        
            console.coverConsole = ivCoverConsole.image
        
            do {
                try self.context.save()
            } catch {
                print("Erro ao inserir")
            }
        
       navigationController?.popViewController(animated: true)
    }
    
    func updateConsole(){
        
        if lbNameConsole?.text == "" {
           dialogMessage()
        } else {
            myConsole.name = lbNameConsole?.text
            myConsole.coverConsole = ivCoverConsole.image
            navigationController?.popViewController(animated: true)
        }
    }
    
    func dialogMessage(){
        let alert = UIAlertController(title: "Ops", message: "O nome do console não pode ser vazio.", preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(actionOK)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func btSetCoverConsole(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecinoar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.chooseImageFromLibrary(sourceType: sourceType)
                }
            })
        } else if photos == .authorized {
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
}

extension ConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.ivCoverConsole.image = pickedImage
                self.ivCoverConsole.setNeedsDisplay()
                self.buttonCoverConsole.setTitle(nil, for: .normal)
                self.buttonCoverConsole.setNeedsDisplay()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
