//
//  AddViewController.swift
//  ShoppingList
//
//  Created by Adam Kuniholm on 6/20/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

  var toAdd : String = ""
  
  
  @IBAction func cancelButton(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  

  
  override func viewWillAppear(animated: Bool) {
    navigationItem.title = "Add Item to List"
  }

  @IBOutlet weak var itemToAddTextField: UITextField!
  
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if let tfield = itemToAddTextField { toAdd = tfield.text! }
      else { toAdd = "" }
  
  }
  
}
