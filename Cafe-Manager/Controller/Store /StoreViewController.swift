//
//  StoreViewController.swift
//  Cafe-Manager
//
//  Created by Imalka Muthukumara on 2021-04-14.
//

import UIKit
import Firebase

class StoreViewController: UIViewController {
    var ref = Database.database().reference()
    
    var category:Category = Category(categoryID: "", categoryName: "")
    
    var categoryCollection:[Category] = [Category(categoryID: "Main", categoryName: "fruits"),Category(categoryID: "sda", categoryName: "ssadad")]
    
    var categoryWiseFoods:[CategoryItems] = []
    
    @IBOutlet weak var previewBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var previewTable: UITableView!
    
    var foodItemArray:[FoodItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategorys()
        
        //getFoodItems()
        ref = Database.database().reference()
        previewTable.register(UINib(nibName: K.previewTable.nibNameCategoryTable, bundle: nil), forCellReuseIdentifier: K.previewTable.categoryTableCell)
        
        setupCustomUI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.previewTable.reloadData()
        }
    }
    func setupCustomUI(){
        CustomUI.setupAuthButton(btnCustom: previewBtn)
        CustomUI.setupAuthButton(btnCustom: menuBtn)
        CustomUI.setupAuthButton(btnCustom: categoryBtn)
    }
    
}

extension StoreViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryWiseFoods[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = previewTable.dequeueReusableCell(withIdentifier: K.previewTable.categoryTableCell, for: indexPath) as! FoodPreviewTableViewCell
        
        let category = categoryWiseFoods[indexPath.section]
        let drink = category.items[indexPath.row]
        
        cell.setupView(foodItem: drink)
        
        return cell

        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryWiseFoods[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        categoryWiseFoods.count
    }
}

extension StoreViewController{
    
    func getFoodItems(){
        
        //self.orders.removeAll()
        for categorys in StoreHandler.categoryCollection{
            
            self.ref.child("FoodItemsCafe").child(categorys.categoryName)
                .observe(.value) { (snapshot) in
                    self.foodItemArray = []
                    if let data = snapshot.value {
                        
                        if let foodItems = data as? [String:Any]{
                            // print(foodItems.keys)
                            for singleItem in foodItems{
                                //print(singleItem)
                                if let itemInfo = singleItem.value as? [String:Any]{
                                    var foodItems = FoodItem()
                                    foodItems.id = singleItem.key
                                    foodItems.foodName = itemInfo["foodName"] as! String
                                    foodItems.foodDescription = itemInfo["foodDescription"] as! String
                                    foodItems.foodPrice = itemInfo["price"] as! Double
                                    foodItems.discount = itemInfo["discount"] as! Int
                                    foodItems.isAvailable = itemInfo["available"] as! Bool
                                    foodItems.image = itemInfo["imageURL"] as! String
                                    
                                    self.foodItemArray.append(foodItems)
                                    
                                    //print(foodItems.foodName)
                                    //foodItemArray.append(<#T##newElement: FoodItem##FoodItem#>)
                                    //print(orderInfo)
                                }
                                
                            }
                            
                            self.categoryWiseFoods.append(CategoryItems(name: categorys.categoryName, items: self.foodItemArray))
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.previewTable.reloadData()
                    }
                   
                }

        }
    }
    func getCategorys(){
        
        self.ref.child("category").observe(.value) { (snapshot) in
            if let data = snapshot.value{
                if let orders = data as? [String:Any]{
                    StoreHandler.categoryCollection.removeAll()
                    for singleCategory in orders{
                        if let categoryInfo = singleCategory.value as? [String:Any]{
                            self.category.categoryName = categoryInfo["categoryName"] as! String
                            self.category.categoryID = singleCategory.key
                            StoreHandler.categoryCollection.append(self.category)
                        }
                    }
                    //  print(StoreHandler.categoryCollection)getFoodItems
                    self.getFoodItems()
                }
            }
        }
    }
}
