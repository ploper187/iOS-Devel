//
//  ReusableTaskCell.swift
//  Priorities
//
//  Created by Adam Kuniholm on 7/23/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit

class ReusableTaskCell: UITableViewCell {
  var circleRadius : CGFloat = 5
  var animationDuration : Double = 0.5
  var delegate : TaskCellDelegate?
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var locationLabel: UILabel!
 
  @IBOutlet var topButton: UIButton!
  @IBOutlet var midButton: UIButton!
  @IBOutlet var bottomButton: UIButton!
  
  
  
  @IBAction func topButtonHit(_ sender: UIButton) {
    delegate?.topButtonHit(self)
  }

  @IBAction func midButtonHit(_ sender: UIButton) {
    delegate?.midButtonHit(self)
  }
  
  @IBAction func bottomButtonHit(_ sender: UIButton) {
    delegate?.bottomButtonHit(self)
  }
  

  func panInView(_ sender : UIPanGestureRecognizer) {
    delegate?.dragInCell(self, recognizer: sender)
  }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      self.bottomButton.center.x = self.midButton.center.x
      self.topButton.center.x = self.midButton.center.x
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  
  func executeFloodAnimation(atLocation : CGPoint, withColor : UIColor, duration : Double = 0.5) {
    let currentShapeLayer = CAShapeLayer()
    let adjustedButtonCenter = CGPoint(x: atLocation.x-CONSTANT.borderMargin, y: atLocation.y)
    let smallCircle = UIBezierPath(arcCenter: adjustedButtonCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true).cgPath
    let largeCircle = UIBezierPath(arcCenter: atLocation, radius: 800, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true).cgPath
    let bottomRect = UIBezierPath(rect: CGRect(x: self.frame.height, y: self.frame.width - (circleRadius+8), width: circleRadius, height: self.frame.height/2)).cgPath
    let rectLayer = CAShapeLayer()
    
    currentShapeLayer.masksToBounds = false
    //currentShapeLayer.contentsRect = bounds
    currentShapeLayer.frame = bounds
    
    rectLayer.path = bottomRect
    
    currentShapeLayer.path = smallCircle
    currentShapeLayer.fillColor = withColor.cgColor
    currentShapeLayer.opacity = 0
    
    let animation = CABasicAnimation(keyPath: "path")
    animation.toValue = largeCircle
    animation.duration = duration
    animation.autoreverses = true
    
    let colorAnimation = CABasicAnimation(keyPath: "opacity")
    colorAnimation.toValue = 0.8
    colorAnimation.fromValue = 0
    colorAnimation.duration = duration
    colorAnimation.autoreverses = true
    
    colorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    
    colorAnimation.isRemovedOnCompletion = false
    animation.isRemovedOnCompletion = false
    
    self.contentView.layer.addSublayer(currentShapeLayer)
    
    currentShapeLayer.add(animation, forKey: "path")
    currentShapeLayer.add(colorAnimation, forKey: "opacity")
  }

}
