//
//  ViewController.swift
//  Todoey
//
//  Created by Lavneesh Chandna on 2/25/19.
//  Copyright © 2019 Lavneesh Chandna. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray : [TodoItem] = Array<TodoItem>();
    
    var selectedCategory: Category? {
        didSet {
            loadData();
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
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
        let addItemAlert = UIAlertController(title: "Add Item", message: "Add Todo Item", preferredStyle: .alert);
        addItemAlert.addTextField { (textField) in
            textField.placeholder = "Todo Item Name";
            newTodoTextField = textField;
        }
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Add new item")
            let newItem = TodoItem(context: self.context);
            newItem.title = newTodoTextField!.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory!;
            self.itemArray.append(newItem)
            self.saveData();
        }
        addItemAlert.addAction(addItemAction);
        present(addItemAlert, animated: true);
    }
    
    func saveData(){
        do{
            try context.save()
        }catch {
            print("Error while encoding property list:");
        }
        tableView.reloadData();
    }
    
    func loadData(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        do{
            let defaultPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!);
            if let additionalPredicate = predicate {
                let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [defaultPredicate, additionalPredicate]);
                request.predicate = combinedPredicate;
            }else{
                request.predicate = defaultPredicate;
            }
            itemArray = try context.fetch(request);
        }catch {
            
        }
        tableView.reloadData();
    }
    
}


//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest();
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)];
        loadData(with: request, predicate: predicate);
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

