//
//  ReceiptTableViewController.swift
//  iReadReceipts
//
//  Created by Adam Kuniholm on 6/24/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit

class ReceiptTableViewController: UITableViewController, UITextFieldDelegate {
  
  var masterList = [ReceiptItem]()
  var nameTextField : UITextField!
  var priceTextField : UITextField!
  var SKUTextField : UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ReceiptTableViewController.didSwipe(_:)))
    self.tableView.addGestureRecognizer(swipeRecognizer)
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReceiptTableViewController.didTap(_:)))
    self.tableView.addGestureRecognizer(tapRecognizer)
    
    
    masterList.append(ReceiptItem(name: "Peanut Butter!", price: 5.35))
    masterList.append(ReceiptItem(name: "Peanut Butter!", price: 5.35))
    masterList.append(ReceiptItem(name: "Peanut Butter!", price: 5.35))
    
    
  }
  func didTap(recognizer : UIGestureRecognizer) {
    if recognizer.state == UIGestureRecognizerState.Ended {
      let swipeLocation = recognizer.locationInView(self.tableView)
      if let swipedIndexPath = tableView.indexPathForRowAtPoint(swipeLocation) {
        if let swipedCell = self.tableView.cellForRowAtIndexPath(swipedIndexPath) as? ReceiptItemCell {
          if swipedCell.canEdit {
            priceTextField = swipedCell.priceTextField
            swipedCell.selectField("Price")
            priceTextField.delegate = self
            priceTextField.becomeFirstResponder()
          }
        }
      }
    }
  }
  
  
  func didSwipe(recognizer : UIGestureRecognizer) {
    if recognizer.state == UIGestureRecognizerState.Ended {
      let swipeLocation = recognizer.locationInView(self.tableView)
      if let swipedIndexPath = tableView.indexPathForRowAtPoint(swipeLocation) {
        if let swipedCell = self.tableView.cellForRowAtIndexPath(swipedIndexPath) as? ReceiptItemCell {
          if swipedCell.canEdit {
            nameTextField = swipedCell.nameTextField
            swipedCell.selectField("Name")
            nameTextField.delegate = self
            nameTextField.becomeFirstResponder()
          }
        }
      }
    }
  }
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return masterList.count != 0 // allows changes to (deletion of) cells
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if !masterList.contains(masterList[indexPath.row]) { return }
    masterList.removeAtIndex(masterList.indexOf(masterList[indexPath.row])!)
    tableView.reloadData()
  }
  
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if masterList.count == 0 {  return 1  }
    return masterList.count
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if masterList.count == 0 {
      let cell = self.tableView.dequeueReusableCellWithIdentifier("ZeroCell", forIndexPath: indexPath) as UITableViewCell
      cell.textLabel?.textAlignment = .Center
      cell.userInteractionEnabled = false
      cell.textLabel?.text = "Nothing to see here!"
      return cell
    }
    let cell = self.tableView.dequeueReusableCellWithIdentifier("ReceiptItemCell", forIndexPath: indexPath) as? ReceiptItemCell
    cell!.tableController = self
    cell!.name = masterList[indexPath.row].name
    cell!.price = masterList[indexPath.row].price
    if let cellSKU = masterList[indexPath.row].SKU {
      cell!.SKU = cellSKU
    }
    cell?.canEdit = true

    return cell!
  }
  
  func textFieldShouldReturn(userText: UITextField) -> Bool {
    userText.resignFirstResponder()
    view.endEditing(true)
    return true
  }
  
  
  


  

}
