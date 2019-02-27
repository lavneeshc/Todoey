//
//  ViewController.swift
//  Todoey
//
//  Created by Lavneesh Chandna on 2/25/19.
//  Copyright © 2019 Lavneesh Chandna. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray : [TodoItem] = Array<TodoItem>();
    
    let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("todoItems.plist");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath);
        let item = itemArray[indexPath.row];
        
        cell.textLabel?.text = item.title;
        cell.accessoryType = item.done ? .checkmark : .none;
        return cell;
    }

    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked at : \(itemArray[indexPath.row])");
        tableView.deselectRow(at: indexPath, animated: true);
        let item = itemArray[indexPath.row];
        item.done = !item.done;
        saveData();
    }
    
    
    //MARK - Add new items
    @IBAction func addTodoItemClicked(_ sender: UIBarButtonItem) {
        var newTodoTextField : UITextField?;
        let addItemAlert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert);
        addItemAlert.addTextField { (textField) in
            textField.placeholder = "Todo Item Name";
            newTodoTextField = textField;
        }
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Add new item")
            let newItem = TodoItem()
            newItem.title = newTodoTextField!.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveData();
        }
        addItemAlert.addAction(addItemAction);
        present(addItemAlert, animated: true);
    }
    
    func saveData(){
        let encoder = PropertyListEncoder()
        do{
            let encodedData = try encoder.encode(itemArray);
            try encodedData.write(to: file!);
        }catch {
            print("Error while encoding property list:");
        }
        tableView.reloadData();
    }
    
    func loadData() {
            if let data = try? Data(contentsOf: file!) {
                let decoder = PropertyListDecoder();
                do{
                    itemArray = try decoder.decode([TodoItem].self, from: data);
                }catch{
                    
                }
            }
    }
    
}

