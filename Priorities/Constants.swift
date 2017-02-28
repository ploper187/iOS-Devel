//
//  Constants.swift
//  Priorities
//
//  Created by Adam Kuniholm on 8/6/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import Foundation
import UIKit

struct CONSTANT {
  static let borderRadius : CGFloat = 4
  static let borderMargin : CGFloat = 8
  static let buttonMagnitude : CGFloat = 34
  static let cellHeight : CGFloat = 140
  static let textContainerHeight : CGFloat = 19
}

struct FILENAME {
  static let Tick = "Tick.png"
  static let DeleteO = "DeleteO.png"
  static let Location = "Location.png"
  static let PullDownSlim = "PullDownSlim.png"
  static let PullDownWide = "PullDownWide.png"
  static let SettingsPersonal = "SettingsPersonal.png"
  static let DeleteX = "DeleteX.png"
  static let Elipses = "Elipses.png"
  static let DragSettings = "drag_options_2.png"
  static let RedArrow = "RedArrowLeft.png"
}


struct IMAGE {
  static let Tick : UIImage = UIImage(named: FILENAME.Tick)!
  static let DeleteO : UIImage = UIImage(named: FILENAME.DeleteO)!
  static let Location : UIImage = UIImage(named: FILENAME.Location)!
  static let PullDownSlim : UIImage = UIImage(named: FILENAME.PullDownSlim)!
  static let PullDownWide : UIImage = UIImage(named: FILENAME.PullDownWide)!
  static let SettingsPersonal : UIImage = UIImage(named: FILENAME.SettingsPersonal)!
  static let DeleteX : UIImage = UIImage(named: FILENAME.DeleteX)!
  static let Elipses : UIImage = UIImage(named: FILENAME.Elipses)!
  static let DragSettings : UIImage = UIImage(named: FILENAME.DragSettings)!
  static let RedArrow : UIImage = UIImage(named: FILENAME.RedArrow)!
}

struct COLOR {
  static let settingsColor = UIColor(red: 240/255, green: 83/255, blue: 81/255, alpha: 0.9)
  static let locationButtonColor = UIColor(red: 52/255, green: 151/255, blue: 181/255, alpha: 0.9)
  static let tickButtonColor = UIColor(red: 123/255, green: 188/255, blue: 155/255, alpha: 0.9)
}
