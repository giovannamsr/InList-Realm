//
//  CategoryViewController.swift
//  InList
//
//  Created by Giovanna Rodrigues on 13/10/21.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryList = [ToDoCategory]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return categoryList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categoryList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category.categoryName
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemsView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToItemsView"{
            let destinationVC = segue.destination as! ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoryList[indexPath.row]
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCell.EditingStyle.delete {
            context.delete(categoryList[indexPath.row])
            categoryList.remove(at: indexPath.row)
            saveData()
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    @IBAction func addPressed(_ sender: UIBarButtonItem){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default){ [self] (action) in
            if let text = textField.text{
                if text != ""{
                    let userNewCategory = ToDoCategory(context: context)
                    userNewCategory.categoryName = text
                    self.categoryList.append(userNewCategory)
                    saveData()
                }
            }
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Name"
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
    
    func loadData(with request: NSFetchRequest<ToDoCategory> = ToDoCategory.fetchRequest()){
        do{
           categoryList = try context.fetch(request)
        }catch{
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
}
