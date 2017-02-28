//
//  Task.swift
//  Priorities
//
//  Created by Adam Kuniholm on 7/28/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct CoderKeys {
  static let nameKey = "name"
  static let descriptionKey = "desc"
  static let longitudeKey = "longitude"
  static let latitudeKey = "latitude"
}

class Task : NSObject, NSCoding {

  var name : String?
  var desc : String?
  var latitude : Double?
  var longitude : Double?
  
  static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")

  init(name : String?, description desc : String?, longitude : Double?, latitude : Double?) {
    self.name = name
    self.desc = desc
    self.longitude = longitude
    self.latitude = latitude
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let name = aDecoder.decodeObject(forKey: CoderKeys.nameKey) as? String
    let desc = aDecoder.decodeObject(forKey: CoderKeys.descriptionKey) as? String
    let longitude = aDecoder.decodeObject(forKey: CoderKeys.longitudeKey) as? Double
    let latitude = aDecoder.decodeObject(forKey: CoderKeys.latitudeKey) as? Double
    self.init(name: name, description : desc, longitude: longitude, latitude: latitude)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: CoderKeys.nameKey)
    aCoder.encode(desc, forKey: CoderKeys.descriptionKey)
    aCoder.encode(longitude, forKey: CoderKeys.longitudeKey)
    aCoder.encode(latitude, forKey: CoderKeys.latitudeKey)
  }
}
