//
//  ReceiptItem.swift
//  iReadReceipts
//
//  Created by Adam Kuniholm on 6/24/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import Foundation

class ReceiptItem : Equatable {
  var name : String
  var price : Double
  var SKU : String?
  var fromStore : Store?
  var boughtOnDate : Date?
  
  init(name : String, price : Double){
    self.name = name
    self.price = price
  }

}

func ==(one : ReceiptItem, two : ReceiptItem) -> Bool {
  return one.name == two.name && one.price == two.price
}

class Store {
  let name : String = ""
  let location : String = ""
}

