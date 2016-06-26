//
//  ReceiptItem.swift
//  iReadReceipts
//
//  Created by Adam Kuniholm on 6/24/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit
import Foundation

class ReceiptItemCell: UITableViewCell {
  
  // MARK: Text Fields
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var SKUTextField: UITextField!
  
  @IBOutlet weak var priceTextField: UITextField!
  // MARK: Labels
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var SKULabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  // MARK: Parent Table VC
  var tableController : UITableViewController?
  // MARK: Variables/Setters
  var name : String {
    get { return "Name" }
    set { nameLabel.text = newValue }
  }
  var price : Double {
    get { return 0 }
    set { priceLabel.text = "$\(newValue)" }
  }
  var SKU : String {
    get { return "SKU" }
    set { SKULabel.text = newValue }
    
  }
  var canEdit : Bool = false
  
  func textFieldShouldReturn(userText: UITextField) -> Bool {
    userText.resignFirstResponder()
    tableController!.view.endEditing(true)
    return true
  }

  
  // MARK: Functions
  func selectField(sender : String) {
    if sender == "SKU" {
      SKUTextField.returnKeyType = UIReturnKeyType.Done
      SKULabel.hidden = true
      SKUTextField.placeholder = SKULabel.text
      SKUTextField.hidden = false
      //SKUTextField.becomeFirstResponder()
      return
    }
    if sender == "Name" {
      nameLabel.hidden = true
      nameTextField.returnKeyType = UIReturnKeyType.Done
      nameTextField.placeholder = nameLabel.text
      nameTextField.hidden = false
      //nameTextField.becomeFirstResponder()
      return
    }
    if sender == "Price" {
      priceLabel.hidden = true
      priceTextField.returnKeyType = UIReturnKeyType.Done
      priceTextField.placeholder = priceLabel.text
      priceTextField.hidden = false
      //priceTextField.becomeFirstResponder()
      return
    }
    
  }
  
  func resignTextFields() {
    priceTextField.hidden = true
    nameTextField.hidden = true
    SKUTextField.hidden = true
  }
  
  func labelView() {
    if priceTextField.text != "" { priceLabel.text = priceTextField.text }
    if SKUTextField.text != ""   { SKULabel.text = SKUTextField.text }
    if nameTextField.text != ""   { nameLabel.text = nameTextField.text }
    priceTextField.hidden = true
    nameTextField.hidden = true
    SKUTextField.hidden = true
    nameLabel.hidden = false
    priceLabel.hidden = false
    SKULabel.hidden = false
    
  }
  
  
  
  
  
  
  
  
  
  
}

