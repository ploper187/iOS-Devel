//
//  SettingsView.swift
//  Priorities
//
//  Created by Adam Kuniholm on 8/3/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit

class SettingsView: UIView {
  
  var cancelButton = UIButton(type: UIButtonType.custom)
  var confirmButton = UIButton(type: UIButtonType.custom)
  var cell = ReusableTaskCell()
  
  
  convenience init(cell : ReusableTaskCell, frame : CGRect){
    self.init(frame: cell.bounds)
    self.addBorder(frame: frame, radius: CONSTANT.borderRadius)
    self.cell = cell
    self.cancelButton.center.y = self.frame.height/2
    self.cancelButton.frame.origin.x = self.frame.width - CONSTANT.buttonMagnitude - 2*CONSTANT.borderMargin
    self.cancelButton.setImage(IMAGE.DeleteX, for: UIControlState())
    self.cancelButton.frame.size = CGSize(width: CONSTANT.buttonMagnitude, height: CONSTANT.buttonMagnitude)
    self.addSubview(cancelButton)
    self.bringSubview(toFront: cancelButton)
    
    self.frame.origin.x = cell.frame.maxX
    self.backgroundColor = UIColor.white
    let settingsLabel = UILabel(frame:CGRect(x: 0, y: 0,
                                             width: self.frame.width, height: CONSTANT.textContainerHeight))
    settingsLabel.center.y = self.center.y
    settingsLabel.textAlignment = .center
    settingsLabel.text = "Settings!"
    self.addSubview(settingsLabel)
    
    print(cancelButton.center)
  }
  
  
}
