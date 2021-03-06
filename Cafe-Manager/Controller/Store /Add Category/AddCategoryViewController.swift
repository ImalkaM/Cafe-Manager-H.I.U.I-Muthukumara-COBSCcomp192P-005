//
//  AddCategoryViewController.swift
//  Cafe-Manager
//
//  Created by Imalka Muthukumara on 2021-04-14.
//

import UIKit
import Firebase
import Loaf

class AddCategoryViewController: UIViewController {
    var ref: DatabaseReference!
    var category:Category = Category()
   var categoryCollection:[Category] = []
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var categoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupCustomUI()
        categoryTable.register(UINib(nibName: K.category.nibNameCategoryTable, bundle: nil), forCellReuseIdentifier: K.category.categoryTableCell)
        getCategorys()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let catName = categoryTextField.text{
            if catName.isEmpty{
                Loaf("Category name cannot be empty.", state: .error, sender: self).show()
            }else{
                category.categoryName = catName
                createCategory()
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func setupCustomUI(){
        CustomUI.setupTextField(txtField: categoryTextField)
        CustomUI.setupAuthButton(btnCustom: addButton)
    }
    
    func createCategory(){
        let categoryData = [
            "categoryName" : category.categoryName
        ]
        self.ref.child("category")
            .childByAutoId()
            .setValue(categoryData){ (error, ref) in
                if let err =  error{
                    Loaf("\(err.localizedDescription)", state: .error, sender: self).show()
                }
                else{
                    self.categoryTable.reloadData()
                    Loaf("Category added successfully", state: .success, sender: self).show()
                    self.dismiss(animated: true, completion: nil)
                }
            }
    }
    
//        func getCategorys(){
//
//            self.ref.child("category").observe(.value) { (snapshot) in
//                if let data = snapshot.value{
//                    if let orders = data as? [String:Any]{
//                       StoreHandler.categoryCollection.removeAll()
//                        for singleCategory in orders{
//                            if let categoryInfo = singleCategory.value as? [String:Any]{
//                                self.category.categoryName = categoryInfo["categoryName"] as! String
//                                self.category.categoryID = singleCategory.key
//                                StoreHandler.categoryCollection.append(self.category)
//                            }
//                        }
//                        self.categoryTable.reloadData()
//                    }
//                }
//            }
//        }
    
    func getCategorys(){

        self.ref.child("category").observe(.value) { (snapshot) in
            if let data = snapshot.value{
                if let orders = data as? [String:Any]{
                   self.categoryCollection.removeAll()
                    for singleCategory in orders{
                        if let categoryInfo = singleCategory.value as? [String:Any]{
                            self.category.categoryName = categoryInfo["categoryName"] as! String
                            self.category.categoryID = singleCategory.key
                            self.categoryCollection.append(self.category)
                        }
                    }
                    self.categoryTable.reloadData()
                }
            }
        }
    }
    
    func deleteCategory(index:Int){
        
        self.ref.child("category").child(self.categoryCollection[index].categoryID).removeValue { (err, ref) in
            if err != nil{
                
            }
        }
    }
}

extension AddCategoryViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: K.category.categoryTableCell, for: indexPath) as! CategoryTableViewCell
        
        cell.setupUI(category: self.categoryCollection[indexPath.row])
        //cell.setupUI(order: orders[indexPath.row])
        
        return cell
    }
   
    
}
extension AddCategoryViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategory(index: indexPath.row)
            self.categoryCollection.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.categoryCollection.removeAll()
            self.getCategorys()
            DispatchQueue.main.async {
                self.categoryTable.reloadData()
            }
        
           //getCategorys()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
