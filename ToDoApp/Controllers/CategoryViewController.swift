//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Stoica Valentin on 08/02/2019.
//  Copyright © 2019 Stoica Valentin. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
   
     // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories(){
        
        do{
            try context.save()
        } catch{
            print("error \(error)")
        }
        
        tableView.reloadData()
    }
    
    //func loadItems
    //with = external parameter;   request = internal parameter-inside function
    // dupa "=" reprezinta default parameter
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error loading Categories")
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on our UIAlert
            
            let newCategory = Category(context: self.context )
            newCategory.name = textField.text!
            //newCategory.done = false
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category!"
            textField = alertTextField

        }
        
        present(alert, animated: true, completion: nil)
    }
    
   
   
    
    
    
    
    
}
