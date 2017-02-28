//
//  MapView.swift
//  Priorities
//
//  Created by Adam Kuniholm on 8/3/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class MapView : MKMapView {
  
  var customDelegate: MapViewDelegate?
  var cellBorderMargin : CGFloat = CONSTANT.borderMargin
  let cancelButton = UIButton(type : UIButtonType.custom)
  let confirmButton = UIButton(type: UIButtonType.custom)
  let searchButton = UIButton(type: UIButtonType.custom)
  let buttonSize : CGFloat = CONSTANT.buttonMagnitude
  
  convenience init(cell : ReusableTaskCell, frame : CGRect) {
    self.init(frame : frame)
    let adjustedMidButtonCenter = CGPoint(x: self.frame.width - self.buttonSize,
                                          y: self.frame.height/2)
    let adjustedBottomButtonCenter = CGPoint(x: adjustedMidButtonCenter.x,
                                             y: adjustedMidButtonCenter.y + self.buttonSize + cellBorderMargin)
    
    let adjustedTopButtonCenter = CGPoint(x: adjustedMidButtonCenter.x,
                                          y: adjustedMidButtonCenter.y - self.buttonSize - cellBorderMargin)
    
    self.searchButton.frame = CGRect(origin: adjustedTopButtonCenter, size: cell.topButton.frame.size)
    self.searchButton.setImage(IMAGE.DeleteO, for: UIControlState())
    self.searchButton.alpha = 0
    self.addSubview(searchButton)
    
    self.cancelButton.frame = CGRect(origin: adjustedMidButtonCenter, size: cell.midButton.frame.size)
    self.cancelButton.setImage(IMAGE.DeleteX, for: UIControlState())
    self.cancelButton.alpha = 0
    self.addSubview(cancelButton)

    self.confirmButton.frame = CGRect(origin: adjustedBottomButtonCenter, size: cell.bottomButton.frame.size)
    
    self.confirmButton.setImage(IMAGE.Tick, for: UIControlState())
    self.confirmButton.alpha = 0
    self.addSubview(confirmButton)
    
    self.layer.shadowOffset = CGSize(width: -1, height: -1)
    self.layer.cornerRadius = CONSTANT.borderRadius
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.5
    self.layer.shadowRadius = 3.0
    self.showsUserLocation = true
    
    self.confirmButton.addTarget(self, action: #selector(confirmButtonHit), for: UIControlEvents.touchUpInside)
    self.cancelButton.addTarget(self, action: #selector(cancelButtonHit), for: UIControlEvents.touchUpInside)
    
    self.bringSubview(toFront: cancelButton)
    self.bringSubview(toFront: confirmButton)
  }
  
  func confirmButtonHit() {
    customDelegate?.confirmButtonHit(self)
  }
  func cancelButtonHit() {
    customDelegate?.cancelButtonHit(self)
  }
  
  override func draw(_ rect: CGRect) {
     super.draw(rect)
    let adjustedMidButtonCenter = CGPoint(x: self.frame.width - self.buttonSize,
                                          y: self.frame.height/2)
    let adjustedBottomButtonCenter = CGPoint(x: adjustedMidButtonCenter.x,
                                             y: adjustedMidButtonCenter.y + self.buttonSize + cellBorderMargin)
    let adjustedTopButtonCenter = CGPoint(x: adjustedMidButtonCenter.x,
                                          y: adjustedMidButtonCenter.y - self.buttonSize - cellBorderMargin)
    self.cancelButton.center = adjustedMidButtonCenter
    self.searchButton.center = adjustedTopButtonCenter
    self.confirmButton.center = adjustedBottomButtonCenter
  }
  
  
  
}
