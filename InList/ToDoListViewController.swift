//
//  ViewController.swift
//  InList
//
//  Created by Giovanna Rodrigues on 05/10/21.
//

import UIKit

class ToDoListViewController: UITableViewController{

    var toDoList = [ToDoItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    //Table View datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = toDoList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.description
        cell.accessoryType = item.isCompleted ? .checkmark : .none

        return cell
    }
    
    //Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoList[indexPath.row].isCompleted = !toDoList[indexPath.row].isCompleted
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            toDoList.remove(at: indexPath.row)
            saveData()
        }
    }
    
    //Add items
    
    @IBAction func addPressed(_ sender: UIBarButtonItem){
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default){ [self] (action) in
            if let text = textField.text{
                if text != ""{
                    let userNewItem = ToDoItem(description: text)
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(toDoList)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding data!: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                toDoList = try decoder.decode([ToDoItem].self, from: data)
            }
            catch{
                print("Error decoding data!: \(error)")
            }
        }
    }
}


