//
//  ViewController.swift
//  InList
//
//  Created by Giovanna Rodrigues on 05/10/21.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{

    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var toDoList: Results<ToDoItem>?
    
    var selectedCategory: ToDoCategory?{
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
//MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoList?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoList?[indexPath.row]{
            cell.textLabel?.text = item.taskDescription
            cell.accessoryType = item.isCompleted ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let item = toDoList?[indexPath.row]{
            do{
                try realm.write{
                    item.isCompleted = !item.isCompleted
                }
            }
            catch{
                print("Error updating item: \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if let item = toDoList?[indexPath.row]{
                do{
                    try realm.write{
                        realm.delete(item)
                    }
                }
                catch{
                    print("Error deleting item: \(error)")
                }
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    @IBAction func addPressed(_ sender: UIBarButtonItem){
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default){ [self] (action) in
            if let text = textField.text, let currentCategory = selectedCategory{
                if text != ""{
                    do{
                        try realm.write{
                            let userNewItem = ToDoItem()
                            userNewItem.taskDescription = text
                            userNewItem.date = Date()
                            currentCategory.items.append(userNewItem)
                        }
                    }
                    catch{
                        print("Error writing data: \(error)")
                    }
                }
            }
            tableView.reloadData()
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Description"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
                  
    }
    
    func loadData(){
        
        toDoList = selectedCategory?.items.sorted(byKeyPath: "taskDescription", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let userSearch = searchBar.text{
            toDoList = toDoList?.filter("taskDescription CONTAINS[cd] %@", userSearch).sorted(byKeyPath: "date", ascending: true)
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text?.count == 0{
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


