//
//  ViewController.swift
//  todoey
//
//  Created by USER on 12/1/18.
//  Copyright © 2018 NovoPayment. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            self.restoreItems()
            self.setNavTitle()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if let item: Item = self.itemArray[indexPath.row] {
            self.setCheckmark(item: item, cell: cell)
        }
        
        return cell
    }
    
    //MARK - Table View Configuration
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            
            if let item: Item = self.itemArray[indexPath.row] {
                item.checked = !item.checked
                self.setCheckmark(item: item, cell: cell)
                self.tableView.reloadData()
                self.persistItems()
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
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!), NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)])
        
        request.sortDescriptors = [(NSSortDescriptor(key: "title", ascending: true))]
        
        fetchItems(with: request)
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
        
        let item = Item(context: self.context)
        item.title = title
        item.checked = false
        item.parentCategory = self.selectedCategory
        
        self.itemArray.append(item)
        
        self.tableView.reloadData()
        
        self.persistItems()
    }
    
    private func persistItems() {
        
        do {
            try self.context.save()
        } catch {
            print("Error saving data")
        }
    }
    
    private func restoreItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
        
        self.fetchItems(with: request)
    }
    
    private func fetchItems(with request: NSFetchRequest<Item>) {
        do {
            self.itemArray = try context.fetch(request)
            
            self.tableView.reloadData()
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
}
