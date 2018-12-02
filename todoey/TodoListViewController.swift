//
//  ViewController.swift
//  todoey
//
//  Created by USER on 12/1/18.
//  Copyright © 2018 NovoPayment. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Rent an appartment", "Buy a Wash machine", "Acquire a TV source", "Buy a TV", "Buy a wifi router"]
    
    let defaults = UserDefaults.standard
    let itemArrayKey = "TodoItemArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.retrievePersistedData()
    }
    
    private func retrievePersistedData() {
        if let array = self.defaults.array(forKey: itemArrayKey) as? [String] {
            self.itemArray = array
        }
    }
    
    //MARK - Table View Configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - Table View Configuration
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            switch(cell.accessoryType) {
                case .none:
                    cell.accessoryType = .checkmark
                default:
                    cell.accessoryType = .none
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Items section
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //user clicked the add item btn within the uialert
            
            if !(textField.text?.isEmpty)! {
                self.itemArray.append(textField.text!)
                self.tableView.reloadData()
                self.defaults.setValue(self.itemArray, forKey: self.itemArrayKey)
            }
            
            print("Success")
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

