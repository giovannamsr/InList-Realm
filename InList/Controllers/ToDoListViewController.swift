//
//  ViewController.swift
//  InList
//
//  Created by Giovanna Rodrigues on 05/10/21.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{

    @IBOutlet weak var searchBar: UISearchBar!
    
    var toDoList = [ToDoItem]()
    
    var selectedCategory: ToDoCategory?{
        didSet{
            loadData()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
//MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let item = toDoList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.taskDescription
        cell.accessoryType = item.isCompleted ? .checkmark : .none

        return cell
    }
    
//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        toDoList[indexPath.row].isCompleted = !toDoList[indexPath.row].isCompleted
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCell.EditingStyle.delete {
            context.delete(toDoList[indexPath.row])
            toDoList.remove(at: indexPath.row)
            saveData()
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    @IBAction func addPressed(_ sender: UIBarButtonItem){
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default){ [self] (action) in
            if let text = textField.text{
                if text != ""{
                    let userNewItem = ToDoItem(context: context)
                    userNewItem.taskDescription = text
                    userNewItem.itemCategory = self.selectedCategory
                    self.toDoList.append(userNewItem)
                    saveData()
                }
            }
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Description"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
                  
    }
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Error saving data: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "itemCategory.categoryName MATCHES %@", selectedCategory!.categoryName!)
        
        if let searchPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
           toDoList = try context.fetch(request)
        }catch{
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        if let userSearch = searchBar.text{
            let predicate = NSPredicate(format: "taskDescription CONTAINS[cd] %@", userSearch)
            request.sortDescriptors = [NSSortDescriptor(key: "taskDescription", ascending: true)]
            loadData(with: request, predicate: predicate)
        }
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


