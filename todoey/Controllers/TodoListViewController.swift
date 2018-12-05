//
//  ViewController.swift
//  todoey
//
//  Created by USER on 12/1/18.
//  Copyright © 2018 NovoPayment. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            self.restoreItems()
            self.setNavTitle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.restoreItems()
    }
    
    //MARK - Table View Configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No items for this category"
        
        if let item: Item = self.todoItems?[indexPath.row] {
            self.setCheckmark(item: item, cell: cell)
        }
        
        return cell
    }
    
    //MARK - Table View Configuration
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            
            if let item: Item = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        item.checked = !item.checked
                    }
                } catch {
                    print("Error updating checked data to realm: \(error)")
                }
                
                self.setCheckmark(item: item, cell: cell)
                self.tableView.reloadData()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setCheckmark(item: Item, cell: UITableViewCell) {
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
    
    private func setNavTitle() {
        self.navigationController?.title = self.selectedCategory?.name
    }
    
}

//MARK - SearchBar configuration
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.todoItems = self.todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.restoreItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK - Extension for CRUD Methods with CoreData
extension TodoListViewController {
    
    private func addItem(title: String) {
        
        if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                    let item = Item()
                    item.title = title
                    item.checked = false
                    currentCategory.items.append(item)
                }
            } catch {
                print("Error saving data to realm: \(error)")
            }
            
        }
        
        self.tableView.reloadData()
    }
    
    private func restoreItems() {
        self.todoItems = self.selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
}
