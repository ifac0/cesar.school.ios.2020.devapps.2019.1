//
//  ViewController.swift
//  CloudKitDemo
//
//  Created by Douglas Frari on 17/08/18.
//  Copyright © 2018 CESAR School. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    //  referencia para table view
    @IBOutlet weak var tableView: UITableView!
    
    
    //  carregar o container público
    let database = CKContainer.default().publicCloudDatabase
    
    var notes = [CKRecord]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        queryDatabase()
        
    }

    @IBAction func onPlusTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Type Something", message: "What would you like to save in a note?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Type Note Here"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            
            //  chamar metodo que salva os dados
            self.saveToCloud(note: text)
            print("Enviar dados: \(text) para o servidor iCloud")
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
    }
    
    func saveToCloud(note: String) {
        let newNote = CKRecord(recordType: "Note")
        newNote.setValue(note, forKey: "content")
        
        // 1 - como enviar os dados para o servidor?
        database.save(newNote) { (record, error) in
            guard record != nil else {
                print(error.debugDescription)
                return
            }
            print("saved record")
        }
    }
    
    
    @objc func queryDatabase() {
        let query = CKQuery(recordType: "Note", predicate: NSPredicate(value: true))
        
        // 2 - como fazer queries para o servidor?
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else {
                print(error.debugDescription)
                return
            }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate! })
            self.notes = sortedRecords
           
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //  total de dados
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //  como recuperar a note e mostrar na cell
        let note = notes[indexPath.row].value(forKey: "content") as! String
        cell.textLabel?.text = note
        
        return cell
    }
}

