//
//  Constants.swift
//  CafeNIBMCustomer
//
//  Created by Imalka Muthukumara on 2021-04-11.
//

import Foundation


struct K {
    static let registerToHomeSeauge = "RegisterToHome"
    static let loginToHomeSeauge = "LoginToHome"
    static let foodTableCell = "MainFoodCell"
    static let nibNameFoodTable = "FoodTableViewCell"
    static let nibNameCartTable = "CartTableViewCell"
    static let nibNameOrderTable = "OrderTableViewCell"
    static let orderTableCell = "OrderTableCell"
    static let cartTableCell = "CartTableCell"
    static let FoodTableToFoodDetailsSeauge = "FoodTableToFoodDetails"
    static let FooddetailsToHomeUnwindSeauge = "FoodDetailsToHome"
    static let launchToHomeSeauge = "LaunchToHome"
    static let launchToLogin = "LaunchToLogin"
    static let OrderTableToOrderDetailsSeauge = "OrderToOrderDetails"
    
    
    
    struct FStoreCart {
        static let collectionNameCartTable = "CartCell"
        static let priceField = "price"
        static let foodNameField = "foodname"
        static let qtyField = "qty"
    }
    
    struct category {
        static let nibNameCategoryTable = "CategoryTableViewCell"
        static let categoryTableCell = "CategoryTableCell"
    }
    struct previewTable {
        static let nibNameCategoryTable = "FoodPreviewTableViewCell"
        static let categoryTableCell = "FoodPCell"
    }
    struct orderTable {
        static let nibNameOrderTable = "OrderTableViewCell"
        static let orderTableCell = "OrderPCell"
    }
    struct orderDetailsTable {
        static let nibNameOrderDetailsTable = "OrderDetailsTableViewCell"
        static let orderDetailsTableCell = "OrderDetailCell"
        static let unwindSeauge = "UnwindFromOrderDetails"
        
        
    }
    struct accountCell {
        static let nibNameAccountDetailsTable = "AccountTableViewCell"
        static let accountTableCell = "AccountCell"
       
    }
    
    struct miniTable {
        static let accountTableCellDetails = "itemCellAccount"
        static let accountTableCellDetailsNib = "CellTableViewCell"
    }
    
}



