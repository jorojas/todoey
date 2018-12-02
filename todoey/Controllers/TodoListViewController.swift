//
//  ViewController.swift
//  todoey
//
//  Created by USER on 12/1/18.
//  Copyright © 2018 NovoPayment. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [TodoItem]()
    
    let defaults = UserDefaults.standard
    let itemArrayKey = "TodoItemArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.restoreItems()
    }
    
    private func retrievePersistedData() {
        if let array = self.defaults.array(forKey: itemArrayKey) as? [TodoItem] {
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
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if let item: TodoItem = self.itemArray[indexPath.row] {
            self.setCheckmark(item: item, cell: cell)
        }
        
        return cell
    }
    
    //MARK - Table View Configuration
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            
            if let item: TodoItem = self.itemArray[indexPath.row] {
                item.checked = !item.checked
                self.setCheckmark(item: item, cell: cell)
                self.tableView.reloadData()
                self.persistItems()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setCheckmark(item: TodoItem, cell: UITableViewCell) {
        cell.accessoryType = (item.checked) ? .checkmark : .none
    }
    
    //MARK - Add new Items section
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //user clicked the add item btn within the uialert
            
            if !(textField.text?.isEmpty)! {
                self.addItem(title: textField.text!)
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

//MARK - Extension for CRUD Methods
extension TodoListViewController {
    private func addItem(title: String) {
        let item = TodoItem()
        item.title = title
        item.checked = false
        
        self.itemArray.append(item)
        
        self.tableView.reloadData()
        
        self.persistItems()
    }
    
    private func persistItems() {
        //self.defaults.setValue(self.itemArray, forKey: self.itemArrayKey)
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding data")
        }
    }
    
    private func restoreItems() {
        do {
            let data = try Data(contentsOf: self.dataFilePath!)
            let decoder = PropertyListDecoder()
            
            self.itemArray = try decoder.decode([TodoItem].self, from: data)
            
        } catch {
            print("Error decoding item array: \(error)")
        }
    }
}
