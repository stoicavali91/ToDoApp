//
//  ViewController.swift
//  ToDoApp
//
//  Created by Stoica Valentin on 24/01/2019.
//  Copyright © 2019 Stoica Valentin. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController {

    var toDoItems : Results<Item>!
    let realm = try! Realm()
    var selectedCategory : Category?{
        didSet{
         loadItems()
        }
    }
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //shows the path to the .sqlite document
        

    }

    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
//let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        } else{
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                //item.done = !item.done
                }}catch{
                    print(error)
                }
        }
        // DELETEING ROWS in database
//        //delete in database
//        context.delete(itemArray[indexPath.row])
//        //delete in app
//        itemArray.remove(at: indexPath.row)
        
//        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
//        saveItems()
//
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
        //what will happen once the user clicks the Add item button on our UIAlert
            
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.dateCreated = Date()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                }
            } catch{
                print("error \(error)")
                }}
            
            self.tableView.reloadData()
//            let newItem = Item(context: self.context )
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
           // self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item!"
            textField = alertTextField
           
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulatig Methods
    
//    func saveItems(){
//
//        do{
//           try context.save()
//        } catch{
//           print(error)
//        }
//
//        self.tableView.reloadData()
//    }
//
//
    //with = external parameter;   request = internal parameter-inside function
    // dupa "=" reprezinta default parameter
    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
   
    
    
    
}
// MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
      
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {

                searchBar.resignFirstResponder() //dispar tastatura si cursorul din searchbar
            }

        }
    }
}
