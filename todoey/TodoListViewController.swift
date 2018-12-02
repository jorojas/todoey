//
//  ViewController.swift
//  todoey
//
//  Created by USER on 12/1/18.
//  Copyright © 2018 NovoPayment. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Rent an appartment", "Buy a Wash machine", "Acquire a TV source", "Buy a TV", "Buy a wifi router"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    // MARK - Table View Configuration
    
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
}

