//
//  SettingsViewController.swift
//  iReadReceipts
//
//  Created by Adam Kuniholm on 6/29/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  @IBOutlet weak var minPurchasePriceLabel: UILabel!
  @IBOutlet weak var minPurchaseSlider: UISlider!
  
  @IBOutlet weak var maxPurchasePriceLabel: UILabel!
  @IBOutlet weak var maxPurchaseSlider: UISlider!
  
  override func viewWillAppear(_ animated: Bool) {
    view.backgroundColor = view.backgroundColor?.withAlphaComponent(0.6)
    
    
    
    let tapExit = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.didSwipe(_:)))
    view.addGestureRecognizer(tapExit)
  }
  
  func didSwipe(_ sender: UIGestureRecognizer) {
    if sender.state == UIGestureRecognizerState.ended {
     
      let gestureLocation = sender.location(in: self.view)
      if minPurchasePriceLabel.frame.contains(gestureLocation) { return }
      if minPurchaseSlider.frame.contains(gestureLocation) { return }
      if maxPurchasePriceLabel.frame.contains(gestureLocation) { return }
      if maxPurchaseSlider.frame.contains(gestureLocation) { return }
      dismiss(animated: true, completion: nil)
    }
    
  }
  
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func minSlider(_ sender: UISlider) {
    minPurchasePriceLabel.text = "\(10*(Int(sender.value)/10))"
    minPurchasePriceLabel.textColor = UIColor(red: CGFloat(Double(minPurchasePriceLabel.text!)!/1000)+0.5, green: 0, blue: 0, alpha: 1)
    //maxPurchaseSlider.minimumValue = Float(10*(Int(sender.value)/10))
    maxPurchaseSlider.value = minPurchaseSlider.value
  }
  
  
  @IBAction func maxSlider(_ sender: UISlider) {
    if (maxPurchaseSlider.value <= minPurchaseSlider.value) {
      return
    }
    //sender.minimumValue = Float(minPurchasePriceLabel.text!)! + 10
    maxPurchasePriceLabel.text = "\(10*(Int(sender.value)/10))"
    maxPurchasePriceLabel.textColor = UIColor(red: CGFloat(Double(maxPurchasePriceLabel.text!)!/1000)+0.5, green: 0, blue: 0, alpha: 1)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destVC = segue.destination as? ReceiptTableViewController {
      destVC.minColorThreshold = Double(minPurchasePriceLabel.text!)!
      destVC.maxColorThreshold = Double(maxPurchasePriceLabel.text!)!
      destVC.tableView.reloadData()
      
    }
  }
  
  
  
}
