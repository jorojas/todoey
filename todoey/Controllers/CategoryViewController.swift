//
//  CategoryViewController.swift
//  todoey
//
//  Created by USER on 12/2/18.
//  Copyright © 2018 NovoPayment. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restore()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = self.categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
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
                    destinationVC.selectedCategory = self.categoryArray[indexPath.row]
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
        let category = Category(context: self.context)
        category.name = title
        
        self.categoryArray.append(category)
        self.tableView.reloadData()
        
        self.persist()
    }
    
    private func persist() {
        do {
            try self.context.save()
        } catch {
            print("Error saving data")
        }
    }
    
    private func restore() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        self.fetch(with: request)
    }
    
    private func fetch(with request: NSFetchRequest<Category>) {
        do {
            self.categoryArray = try context.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
}
