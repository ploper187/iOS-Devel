//
//  ReceiptItem.swift
//  iReadReceipts
//
//  Created by Adam Kuniholm on 6/24/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit
import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ReceiptItemCell: UITableViewCell {
  
  // MARK: Colors
  @IBInspectable
  let extremeLowColor = UIColor(red: 167/255, green: 219/255, blue: 216/255, alpha: 0.2)
  @IBInspectable
  let midRangeColor = UIColor(red: 224/255, green: 228/255, blue: 204/255, alpha: 0.6)
  @IBInspectable
  let upperRangeColor = UIColor(red: 243/255, green: 134/255, blue: 48/255, alpha: 0.8)
  @IBInspectable
  let extremeHighColor = UIColor(red: 250/255, green: 105/255, blue: 0, alpha: 0.95)
  
  
  
  // MARK: Text Fields
  @IBOutlet weak var priceTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var SKUTextField: UITextField!
  // MARK: Labels
  @IBOutlet weak var SKULabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  
  // MARK: Parent Table VC
  var tableController : ReceiptTableViewController?
  // MARK: Variables/Setters
  var name : String {
    get { return "Name" }
    set { nameLabel.text = newValue }
  }
  var price : Double {
    get { return 0 }
    set { if newValue < 0 { return }
      priceLabel.text = "$" + String(format: "%.2f", newValue)
      if price > tableController?.maxColorThreshold {
        //print("Cell set to extremeHighColor")
        backgroundColor = extremeHighColor
        //UIColor(red: 242/255, green: 122/255, blue: 136/255, alpha: 1)
        // f27a88
      }
      else if price < tableController?.minColorThreshold {
        //print("Cell set to extremeLowColor")
        backgroundColor = extremeLowColor
        //UIColor(red: 242/255, green: 232/255, blue: 237/255, alpha: 1)
        // ipod Nano by rotten
      }
      else if price > (tableController?.maxColorThreshold)!/2 {
        //print("Cell set to upperRangeColor")
        backgroundColor = upperRangeColor
        //UIColor(red: 191/255, green: 242/255, blue: 238/255, alpha: 1)
        // Sea Foam by beach_girl_dgd
      }
      else {
        //print("Cell set to midRangeColor")
        backgroundColor = midRangeColor
        //UIColor(red: 131/255, green: 242/255, blue: 233/255, alpha: 1)
      } }
  }
  var SKU : String {
    get { return "SKU" }
    set { SKULabel.text = newValue }
    
  }
  var canEdit : Bool = false
  
  func textFieldShouldReturn(_ userText: UITextField) -> Bool {
    userText.resignFirstResponder()
    tableController!.view.endEditing(true)
    return true
  }

  
  // MARK: Functions
  func selectField(_ sender : String) {
    if sender == "SKU" {
      labelView()
      SKUTextField.returnKeyType = UIReturnKeyType.done
      SKULabel.isHidden = true
      SKUTextField.placeholder = SKULabel.text
      SKUTextField.isHidden = false
      return
    }
    if sender == "Name" {
      labelView()
      nameLabel.isHidden = true
      nameTextField.returnKeyType = UIReturnKeyType.done
      nameTextField.placeholder = nameLabel.text
      nameTextField.isHidden = false
      return
    }
    if sender == "Price" {
      labelView()
      priceLabel.isHidden = true
      priceTextField.keyboardType = .decimalPad
      priceTextField.placeholder = priceLabel.text
      priceTextField.isHidden = false
      return
    }
    
  }
  
  func hideTextFields() {
    priceTextField.isHidden = true
    nameTextField.isHidden = true
    SKUTextField.isHidden = true
  }
  
  func labelView() {
    priceTextField.isHidden = true
    nameTextField.isHidden = true
    SKUTextField.isHidden = true
    nameLabel.isHidden = false
    priceLabel.isHidden = false
    SKULabel.isHidden = false
  }
  
  func commit() {
    if nameTextField.text != "" { name = nameTextField.text! }
    
    if SKUTextField.text != "" {  SKU = SKUTextField.text!   }
    if let price = (Double.init(priceTextField.text!)) {
      if price > 0 {
      self.price = price
      }
    }
    self.layer.cornerRadius = 2.0;
    self.layer.masksToBounds = false;
    self.layer.borderWidth = 0
    self.layer.shadowColor = backgroundColor?.cgColor
    self.layer.shadowOpacity = 0.8
    self.layer.shadowRadius = 2
    self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
  }
  
  
  
  
  
  
  
  
  
}

