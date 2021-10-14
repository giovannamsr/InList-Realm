//
//  CategoryViewController.swift
//  InList
//
//  Created by Giovanna Rodrigues on 13/10/21.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryList: Results<ToDoCategory>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return categoryList?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryList?[indexPath.row].categoryName ?? "No categories added"
        
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
                destinationVC.selectedCategory = categoryList?[indexPath.row]
            }
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
//        if editingStyle == UITableViewCell.EditingStyle.delete {
//            context.delete(categoryList[indexPath.row])
//            categoryList.remove(at: indexPath.row)
//            saveData()
//        }
//    }
    
    //MARK: - Data Manipulation Methods
    
    @IBAction func addPressed(_ sender: UIBarButtonItem){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default){ [self] (action) in
            if let text = textField.text{
                if text != ""{
                    let userNewCategory = ToDoCategory()
                    userNewCategory.categoryName = text
                    saveData(category: userNewCategory)
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
    
    func saveData(category: ToDoCategory){
        do{
            try realm.write{
                realm.add(category)
            }
        }
        catch{
            print("Error adding new category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(){
        
        categoryList = realm.objects(ToDoCategory.self)
        tableView.reloadData()
    }
}
