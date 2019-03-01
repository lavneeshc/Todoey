//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Lavneesh Chandna on 3/1/19.
//  Copyright © 2019 Lavneesh Chandna. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    var categories : [Category] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath);
//        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CategoryCell");
        cell.textLabel!.text = categories[indexPath.row].name;
        return cell;
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldCtl : UITextField?;
        let alert = UIAlertController(title: "Add Item", message: "Add Category", preferredStyle: .alert);
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let cat = Category(context: self.context);
            cat.name = textFieldCtl!.text!;
            self.saveData();
            self.loadData();
        }
        alert.addTextField { (textField) in
            textFieldCtl = textField;
        }
        alert.addAction(addAction);
        present(alert, animated: true, completion: nil);
    }
    
    func saveData() {
        do{
            try context.save()
        }catch {
            
        }
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categories = try context.fetch(request);
        } catch {
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToDetailSegue", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destination = segue.destination as! TodoListViewController;
            destination.selectedCategory = categories[indexPath.row];
        }
    }
    
}
