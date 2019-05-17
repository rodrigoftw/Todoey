//
//  CategoryViewController.swift
//  Todoey
//
//  Created by rodrigoftw on 15/05/2019.
//  Copyright © 2019 rodrigoftw. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist.")
        }
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem .add, target: self, action: #selector(CategoryViewController.myRightSideBarButtonItemTapped(_:)))
        rightBarButton.tintColor = UIColor(hexString: "#FFFFFF")
        self.navigationItem.rightBarButtonItem = rightBarButton
        
//        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(CategoryViewController.myRightSideBarButtonItemTapped(_:)))
//        self.navigationItem.rightBarButtonItem = rightBarButton

    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else { fatalError() }
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
            // What will happen once the user clicks the Add Category Button on the Navigation Bar Button Item
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Add a new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
//    @IBAction func addButtonPressed(_ sender: UIBarButtonItem){
//
//        var textField = UITextField()
//
//        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Add", style: .default) {
//            (action) in
//            // What will happen once the user clicks the Add Category Button on the Navigation Bar Button Item
//
//            let newCategory = Category()
//            newCategory.name = textField.text!
//            newCategory.colour = UIColor.randomFlat.hexValue()
//            self.save(category: newCategory)
//        }
//
//        alert.addAction(action)
//
//        alert.addTextField { (field) in
//            textField = field
//            field.placeholder = "Add a new Category"
//        }
//
//        present(alert, animated: true, completion: nil)
//    }
}

