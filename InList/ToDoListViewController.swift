//
//  ViewController.swift
//  InList
//
//  Created by Giovanna Rodrigues on 05/10/21.
//

import UIKit

class ToDoListViewController: UITableViewController{

    var toDoList = [ToDoItem]()
    let defaults = UserDefaults()
    let exampleCell = ToDoItem(description: "a")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Table View datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = toDoList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.description
        if item.isCompleted{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    //Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoList[indexPath.row].isCompleted = !toDoList[indexPath.row].isCompleted
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            toDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    //Add itens
    
    @IBAction func addPressed(_ sender: UIBarButtonItem){
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default){ (action) in
            if let text = textField.text{
                if text != ""{
                    let userNewItem = ToDoItem(description: text)
                    self.toDoList.append(userNewItem)
                    self.tableView.reloadData()
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
    
}


