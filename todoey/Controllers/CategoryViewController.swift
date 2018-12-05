//
//  CategoryViewController.swift
//  todoey
//
//  Created by USER on 12/2/18.
//  Copyright © 2018 NovoPayment. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restore()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = self.categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier!) {
            case "goToItems":
                let destinationVC = segue.destination as! TodoListViewController
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    destinationVC.selectedCategory = self.categories?[indexPath.row]
                    print("selected category: \(destinationVC.selectedCategory?.name)")
                }
                break
            default:
                break
        }
    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var categoryField = UITextField()
        let alert = UIAlertController(title: "New category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            categoryField = textField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //Add new category
            if categoryField.text!.count > 0 {
                self.addCategory(title: categoryField.text!)
            }
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK - Extension for Model Manipulation
extension CategoryViewController {
    private func addCategory(title: String) {
        let category = Category()
        category.name = title
        
        self.persist(category: category)
        
        self.tableView.reloadData()
    }
    
    private func persist(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data")
        }
    }
    
    private func restore() {
        self.categories = self.realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
}
