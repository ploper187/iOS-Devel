//
//  SettingsView.swift
//  iReadReceipts
//
//  Created by Adam Kuniholm on 7/6/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit

extension UISlider {
  func setUp(_ min : Double, max : Double, curr : Double = -1){
    self.minimumValue = Float(min)
    self.maximumValue = Float(max)
    if curr < 0 { self.value = Float(min) }
    else { self.value = Float(curr) }
    
  }
  
  
}

class SettingsView: UIView {

  @IBOutlet weak var minPurchaseSlider: UISlider!
  @IBOutlet weak var maxPurchaseSlider: UISlider!
  @IBOutlet weak var minPurchaseLabel: UILabel!
  @IBOutlet weak var maxPurchaseLabel: UILabel!
  
//  func viewWillAppear(min minPurchasePrice : Double, max maxPurchasePrice : Double) {
//    //minPurchaseSlider.setUp(minPurchasePrice, max: maxPurchasePrice-10)
//    //maxPurchaseSlider.setUp(minPurchasePrice+10, max: maxPurchasePrice)
//    minPurchaseLabel.text = "\(minPurchasePrice)"
//    maxPurchaseLabel.text = "\(maxPurchasePrice)"
////    let tapExit = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.didSwipe(_:)))
////    addGestureRecognizer(tapExit)
//  }
//  
  required override init(frame :  CGRect) {
    super.init(frame: frame)
    self.frame = frame
    Bundle.main.loadNibNamed("settingsView", owner: self, options: nil)?[0] as! UIView
    
    let tapExit = UITapGestureRecognizer(target: self, action: #selector(SettingsView.didInteractWithGesture(_:)))
    addGestureRecognizer(tapExit)
 
  }
  
  func didInteractWithGesture(_ sender: UIGestureRecognizer) {
    if sender.state == UIGestureRecognizerState.ended {
      print("Interacted!")
      let gestureLocation = sender.location(in: self)
      if minPurchaseLabel.frame.contains(gestureLocation) { return }
      if minPurchaseSlider.frame.contains(gestureLocation) { return }
      if maxPurchaseLabel.frame.contains(gestureLocation) { return }
      if maxPurchaseSlider.frame.contains(gestureLocation) { return }
    }
    
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @IBAction func MinSliderValueDidChange(_ sender: UISlider) {
    minPurchaseLabel.text = "\(Int(10*sender.value)/10)"
    
  }
  
  @IBAction func MaxSliderValueDidChange(_ sender: UISlider) {
    maxPurchaseLabel.text = "\(Int(10*sender.value)/10)"
  }
  

}
