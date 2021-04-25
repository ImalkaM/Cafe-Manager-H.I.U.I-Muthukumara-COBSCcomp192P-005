//
//  OrderViewController.swift
//  Cafe-Manager
//
//  Created by Imalka Muthukumara on 2021-04-24.
//

import UIKit
import Firebase
import Loaf
import SwiftDate

class OrderViewController: UIViewController {

    var ref: DatabaseReference!
    var todayOrders:[Order] = []
    var allOrders:[Order] = []
    var orderUsers:[String] = []
    
    var todayOrdersTest:[OrderTest] = []
    
    var date:Double = 0.0
    var datenow:String = ""
    var currentDate:Date = Date()
    
    @IBOutlet weak var orderTable: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference()
        orderTable.register(UINib(nibName: K.orderTable.nibNameOrderTable, bundle: nil), forCellReuseIdentifier: K.orderTable.orderTableCell)
        getOrderUsers()
    }
}

extension OrderViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todayOrdersTest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTable.dequeueReusableCell(withIdentifier: K.orderTable.orderTableCell, for: indexPath) as! OrderTableViewCell
        
//        let category = categoryWiseFoods[indexPath.section]
//        let drink = category.items[indexPath.row]
//
        cell.setupUI(category: todayOrdersTest[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == orderTable{
            performSegue(withIdentifier: K.OrderTableToOrderDetailsSeauge, sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == K.OrderTableToOrderDetailsSeauge{
            if let indexPath = orderTable.indexPathForSelectedRow {
                let orderDescriptionViewController = segue.destination as! OrderDetailsViewController
                orderDescriptionViewController.setupFoodDescritionView(orderItem: todayOrdersTest[indexPath.row])
            }
        }
        
    }

    
}

extension OrderViewController{
    
    func getOrders(){

        self.todayOrders.removeAll()

        for key in orderUsers{
            self.ref.child("orders").child(key)
                .observe(.value) { (snapshot) in
                    if let data = snapshot.value{
                        if let orders = data as? [String:Any]{
                            for singleOrder in orders{
                                if let orderInfo = singleOrder.value as? [String:Any]{
                                    var placedOrder = Order()
                                    placedOrder.orderID = singleOrder.key
                                    placedOrder.orderStatus = orderInfo["status"] as! String
                                    placedOrder.custName = orderInfo["customerName"] as! String
                                   //
                                    if let orderItems = orderInfo["orderItems"] as? [Any]{
                                        for item in orderItems{

                                           if let itemInfo = item as? [String:Any]{
                                            placedOrder.orderTotal += itemInfo["foodPrice"] as! Double
                                            placedOrder.quantity = itemInfo["qunatity"] as! Int
                                            placedOrder.foodName = itemInfo["foodName"] as! String
                                            self.date = itemInfo["timestamp"] as! Double
                                            self.datenow = self.convertTimestampToString(serverTimestamp: self.date)
                                            self.currentDate = self.convertTimestampToDate(serverTimestamp: self.datenow)
                                            placedOrder.date = self.currentDate
                                            }
                                        }
                                    }
                                    if self.currentDate.compare(.isToday){
                                        self.todayOrders.append(placedOrder)
                                        print(placedOrder)
                                       
                                    }
                                    self.allOrders.append(placedOrder)
                                }
                               self.orderTable.reloadData()
                            }
                        }
                    }
                }
        }

    }
    
    func getOrdersTest(){
        var tempId = 0
        self.todayOrdersTest.removeAll()

        for key in orderUsers{
            self.ref.child("orders").child(key)
                .observe(.value) { (snapshot) in
                    if let data = snapshot.value{
                        if let orders = data as? [String:Any]{
                            for singleOrder in orders{
                                if let orderInfo = singleOrder.value as? [String:Any]{
                                    var placedOrder = OrderTest()
                                    var placedSingleFoodInfo = FoodItemOrder()
                                    placedOrder.orderID = singleOrder.key
                                    placedOrder.orderStatus = orderInfo["status"] as! String
                                    placedOrder.custName = orderInfo["customerName"] as! String
                                   //
                                    if let orderItems = orderInfo["orderItems"] as? [Any]{
                                        for item in orderItems{

                                           if let itemInfo = item as? [String:Any]{
                                            placedOrder.orderTotal += itemInfo["foodPrice"] as! Double
                                            placedSingleFoodInfo.quantity = itemInfo["qunatity"] as! Int
                                            placedSingleFoodInfo.foodName = itemInfo["foodName"] as! String
                                            placedSingleFoodInfo.foodPrice = itemInfo["foodPrice"] as! Double
                                            self.date = itemInfo["timestamp"] as! Double
                                            self.datenow = self.convertTimestampToString(serverTimestamp: self.date)
                                            self.currentDate = self.convertTimestampToDate(serverTimestamp: self.datenow)
                                            placedOrder.date = self.currentDate
                                            placedOrder.foodArray.append(placedSingleFoodInfo)
                                            }
                                        }
                                    }
                                    if self.currentDate.compare(.isToday){
                                        tempId += 1
                                        self.todayOrdersTest.append(placedOrder)
                                        print(placedOrder)
                                       
                                    }
                                   // self.allOrders.append(placedOrder)
                                }
                               self.orderTable.reloadData()
                            }
                        }
                    }
                }
        }

    }
    
    
    func getOrderUsers(){
        
        ref.child("orders").observe(.value, with: {(snapshot) in
            if let data = snapshot.value{
                
                if let userData = data as? [String:Any]{
                    
                    for key in userData.keys{
                        self.orderUsers.append(key)

                    }
                   // self.getOrders()
                    self.getOrdersTest()
                   // print(self.orderUsers)
                }
                
            }
           
        })

    }
    
    func convertTimestampToString(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        
        return formatter.string(from: date as Date)
    }
    
    func convertTimestampToDate(serverTimestamp: String) -> Date {
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        
        return formatter.date(from: serverTimestamp as String) ?? Date()
    }
}
