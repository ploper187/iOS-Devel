//
//  MainViewController.swift
//  ShoppingList
//
//  Created by Adam Kuniholm on 6/20/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

  var list = List()
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // how many cells
    return list.size()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell // what goes in cell!
    cell.textLabel?.text = String(indexPath.row+1) + "  " + list.itemAtIndex(indexPath.row)
    return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    list.remove(list.itemAtIndex(indexPath.row))
    tableView.reloadData()
  }
  
  @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.sourceViewController as?
      AddViewController {
      if !list.contains(sourceViewController.toAdd) && sourceViewController.toAdd.startIndex != sourceViewController.toAdd.endIndex {
      let newIndexPath = NSIndexPath(forRow: list.size(), inSection: 0)
      list.add(sourceViewController.toAdd)
      tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
      }
    }
  }
  
  @IBAction func clearAllButton(sender: UIButton) {
    list.clear()
    tableView.reloadData()
  }
  
 
  
}

