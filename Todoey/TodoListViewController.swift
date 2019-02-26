//
//  ViewController.swift
//  Todoey
//
//  Created by Lavneesh Chandna on 2/25/19.
//  Copyright © 2019 Lavneesh Chandna. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath);
        cell.textLabel?.text = itemArray[indexPath.row];
        return cell;
    }

    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked at : \(itemArray[indexPath.row])");
        tableView.deselectRow(at: indexPath, animated: true);
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        }
    }

}

