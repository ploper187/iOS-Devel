//
//  ManualAddItemViewController.swift
//  iReadReceipts
//
//  Created by Adam Kuniholm on 6/25/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit

class ManualAddItemViewController: UITableViewController {

  var addList = [ReceiptItem]()
  
  let defaultAddListLength = 50
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return defaultAddListLength
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    let cell = self.tableView.dequeueReusableCellWithIdentifier("ReceiptItemCell", forIndexPath: indexPath) as? ReceiptItemCell
    cell!.name = "Item Name"
    cell!.price = 0.00
    cell!.SKU = "SKU # (e.g. 0000000000000)"
    return cell!
  }
  
  
  
  @IBAction func cancelButton(sender: UIBarButtonItem) {
     dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  
  
}
