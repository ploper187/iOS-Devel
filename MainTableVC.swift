//
//  MainTableVC.swift
//  Priorities
//
//  Created by Adam Kuniholm on 7/circleRadius/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol TaskCellDelegate {
  func topButtonHit(_ sender : ReusableTaskCell)
  func midButtonHit(_ sender : ReusableTaskCell)
  func bottomButtonHit(_ sender : ReusableTaskCell)
  func dragInCell(_ sender : ReusableTaskCell, recognizer : UIPanGestureRecognizer)
}

protocol MapViewDelegate {
  func confirmButtonHit(_ sender : MapView)
  func cancelButtonHit(_ sender : MapView)
  func searchButtonHit(_ sender : MapView)
  
}
class MainTableVC: UITableViewController, TaskCellDelegate, MapViewDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate, CLLocationManagerDelegate  {
  
  // MARK: Properties
  var tasks = [Task]()
  let dragCutoff : CGFloat = 0.5
  var locationName : String? = nil
  
  var genericCellInsideFrame : CGRect!
  let locationManager = CLLocationManager()
  let geoCoder = CLGeocoder()
  

  
  let queue = OperationQueue()
  
  
  var currentMapView : MapView? = nil
  var currentSettingsView : SettingsView?
  var currentCell : ReusableTaskCell? = nil
  var currentLocationMapRegion : MKCoordinateRegion? = nil
  var currentCancelLayer : CALayer? = nil
  var panStartedInValidLocation = false
  var gestureRecognizer = UIGestureRecognizer()
  
  
  var inScrollView = true
  // MARK: Data Source Handling
  func saveTasks() {
   let success = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path)
    if !success {
        print("Failed to save!")
    }
    print("Saved")
  }
  func loadTasks() -> [Task]? {
   return NSKeyedUnarchiver.unarchiveObject(withFile: Task.ArchiveURL.path) as? [Task]
  }
  
  override func viewWillDisappear(_ animated: Bool) {
   saveTasks()
  }
  
  // MARK: ViewDidLoad()
  override func viewDidLoad() {
        super.viewDidLoad()
      // Import Cell Nib
        let nib = UINib(nibName: "Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReusableTaskCell")
      // Location Services
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
    
      // cell parameters
      genericCellInsideFrame = CGRect(x: CONSTANT.borderMargin,
                                          y: CONSTANT.borderMargin,
                                          width: self.view.frame.size.width - (2*CONSTANT.borderMargin),
                                          height: CONSTANT.cellHeight-2*CONSTANT.borderMargin)
    if let tasks = loadTasks() {
      self.tasks = tasks
    }
    self.tasks.removeAll()
    self.saveTasks()
    
    tasks.append(Task(name: "Hello!", description: "Description", longitude: nil, latitude: nil))
    tasks.append(Task(name: "Hello!", description: "Description", longitude: nil, latitude: nil))
    tasks.append(Task(name: "Hello!", description: "Description", longitude: nil, latitude: nil))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.navigationItem.setLeftBarButton(self.editButtonItem, animated: true)
    //self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    //self.navigationController?.hidesBarsWhenKeyboardAppears = true
    locationManager.startUpdatingLocation()
    
  }
  
  

  // MARK: Location
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let lastLocation = locations.last {
      let coordinate = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
      currentLocationMapRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
      let geoLocation = CLLocation(latitude: (self.currentLocationMapRegion?.center.latitude)!, longitude: (self.currentLocationMapRegion?.center.longitude)!)
      self.geoCoder.reverseGeocodeLocation(geoLocation, completionHandler: {
        (placemarks, error) in
        self.locationName = self.determineLocation(placemarks)
      })
      if inScrollView {
        currentMapView = nil
        manager.stopUpdatingLocation()
      }
      if let mapView = currentMapView {
        mapView.setRegion(currentLocationMapRegion!, animated: true)
        manager.stopUpdatingLocation()
        manager.startUpdatingLocation()
      }
      
    }
    
  }
  
  
  func determineLocation(_ placemarks : [CLPlacemark]?) -> String {
    var result = String()
    if let list = placemarks {
      if let placemark = list.first {
        if let locale = placemark.locality {
          print(locale)
          result = "\(locale)"
        }
        if let state = placemark.country {
          print(state)
          result += " \(state)"
        }
        if let other = placemark.name {
         result = other
        }
      }
    }
    return result
  }
  // MARK: Buttons
  
  func confirmButtonHit(_ sender : MapView) {
    if let _ = currentCell {
      currentCell!.locationLabel.text = "Location Set"
      currentCell!.locationLabel.text = locationName
      currentCell!.locationLabel.isHidden = false
      let index = (tableView.indexPath(for: currentCell!)! as NSIndexPath).row
      tasks[index].longitude = currentLocationMapRegion?.center.longitude
      tasks[index].latitude = currentLocationMapRegion?.center.latitude
    }
    
    //executeButtonAnimation(currentCell!, color: (COLOR.tickButtonColor), location: (currentCell!.bottomButton.center))
    currentCell!.executeFloodAnimation(atLocation: currentCell!.bottomButton.center, withColor: COLOR.tickButtonColor)
    if let _ = currentSettingsView {
      // handle new information
    }
    self.transitionCellToScrollView(animated: false)
  }

  func cancelButtonHit(_ sender : MapView) {
    locationManager.stopUpdatingLocation()
    self.transitionCellToScrollView(animated: true)
  }
  
  func searchButtonHit(_ sender : MapView) {
    
  }
  
  
  func topButtonHit(_ sender : ReusableTaskCell){
    if inScrollView {
      sender.nameLabel.text = "Top Button Hit"
      //self.executeButtonAnimation(sender, color: COLOR.tickButtonColor, location: sender.topButton.center)
      sender.executeFloodAnimation(atLocation: sender.topButton.center, withColor: COLOR.tickButtonColor)
      self.tasks.remove(at: (self.tableView.indexPath(for: sender)! as NSIndexPath).row)
      self.tableView.deleteRows(at: [self.tableView.indexPath(for: sender)!], with: .fade)
      saveTasks()
    }
  }
  
  func midButtonHit(_ sender : ReusableTaskCell){
    if inScrollView {
      currentCell = sender
      sender.nameLabel.text = "Mid Button Hit"
      currentMapView = MapView(cell: sender, frame: genericCellInsideFrame!)
      currentMapView!.customDelegate = self
      
      
      if let mapView = currentMapView {
        var alpha :CGFloat = 1
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied ||
          !CLLocationManager.locationServicesEnabled(){
          locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied ||
          !CLLocationManager.locationServicesEnabled(){ // in case of not allowed
          print("Not Allowed!")
          mapView.confirmButton.isEnabled = false
          let height : CGFloat = CONSTANT.textContainerHeight
          let warningLabel = UILabel(frame: CGRect(x: 0, y: (mapView.frame.height/2)-height/2,
                                                   width: mapView.frame.width, height: height))
          warningLabel.text = "Location Unknown"
          warningLabel.textAlignment = .center
          warningLabel.alpha = 1
          warningLabel.center.x = self.view.center.x
          mapView.isScrollEnabled = false
          alpha = 0.6
          mapView.addSubview(warningLabel)
        }
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
        if let currRegion = currentLocationMapRegion {
          mapView.setRegion(currRegion, animated: true)
        }
        mapView.alpha = 0
        tableView.isScrollEnabled = false
        inScrollView = false
        //sender.addSubview(mapView)
        sender.contentView.addSubview(mapView)
        
        sender.contentView.bringSubview(toFront: mapView)
        currentMapView?.sizeToFit()
        currentMapView!.center = sender.contentView.center
        UIView.animate(withDuration: 1, animations: {
          //sender.contentView.alpha = 0
          mapView.alpha = alpha
          mapView.confirmButton.alpha = 0.8
          mapView.cancelButton.alpha = mapView.confirmButton.alpha
          mapView.searchButton.alpha = mapView.confirmButton.alpha
        })
        
        //executeButtonAnimation(sender, color: COLOR.locationButtonColor, location: sender.midButton.center)
        sender.executeFloodAnimation(atLocation: sender.midButton.center, withColor: COLOR.locationButtonColor)
        
        //executeButtonAnimation(sender, color: COLOR.locationButtonColor, location:  sender.bottomButton.center)
        sender.executeFloodAnimation(atLocation: sender.bottomButton.center, withColor: COLOR.locationButtonColor)
      }
      
      
    }
  }
  
  func bottomButtonHit(_ sender : ReusableTaskCell){
    if inScrollView {
      if sender.contentView.center.x == sender.center.x {
        sender.contentView.center.x = sender.center.x
        //sender.bottomButton.center.x = sender.midButton.center.x
        sender.nameLabel.text = "Bottom Button Hit"
        UIView.animate(withDuration: 0.1, animations: {
            sender.bottomButton.center.x -= 50
          }, completion: {
            Void in
            print(sender.bottomButton.center)
            
        })
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 1,
                       options: UIViewAnimationOptions.layoutSubviews,
                       animations: {
                        sender.bottomButton.center.x = sender.midButton.center.x
          }, completion: {
            (value: Bool) in
            
        })
        
        //imageView.frame.origin.x = sender.midButton.frame.origin.x - 1.5*imageView.frame.width

        
        //        let imageView = UIImageView(image: IMAGE.RedArrow)
        //        imageView.frame = sender.bottomButton.frame
        //        //imageView.frame.origin.y += sender.bottomButton.frame.height/4
        //        imageView.frame.size = CGSize(width: CONSTANT.buttonMagnitude, height: CONSTANT.buttonMagnitude)
        //        imageView.alpha = 0
        //        sender.addSubview(imageView)
        
        
//        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.autoreverse, animations: {
//        imageView.alpha = 0.5
//        imageView.frame.origin.x = sender.midButton.frame.origin.x - 1.5*imageView.frame.width
//        }, completion: {
//          Void in
//          imageView.removeFromSuperview()
//          self.inScrollView = true
//          })
      }
    }
  }
  
  func dragInCell(_ cell : ReusableTaskCell, recognizer : UIPanGestureRecognizer) {
    if inScrollView {
      
      let location = recognizer.location(in: cell).x
      if recognizer.state == UIGestureRecognizerState.began { // check if touch began in desired location
          currentCell = cell
          currentSettingsView = SettingsView(cell: cell, frame: genericCellInsideFrame!)
          cell.addSubview(currentSettingsView!)
          currentSettingsView!.cancelButton.addTarget(self,
                                                      action: #selector(transitionCellToScrollView),
                                                      for: UIControlEvents.touchUpInside)
        //currentSettingsView!.bringSubview(toFront: (currentSettingsView!.cancelButton))
        //cell.bringSubview(toFront: currentSettingsView!)
          print("Settings view added")
        return
      }
      if let _ = currentSettingsView { // actions while panning
        if location < cell.frame.width-20 {
          currentCell = cell
          currentSettingsView?.frame.origin.x = cell.frame.maxX
          if location >= cell.frame.width*dragCutoff {
            currentSettingsView?.alpha = min(abs(cell.frame.width-location)/(cell.frame.width/2+1), 1)
            cell.contentView.alpha = abs(location*2)/(cell.frame.width)
            if abs(cell.bottomButton.center.x-location)>cell.frame.width/3 {
              UIView.animate(withDuration: 0.2, animations: {
               Void in
                cell.contentView.center.x = location - (cell.frame.width-cell.bottomButton.frame.width)/2
              })
            }
            else {
            cell.contentView.center.x = location - (cell.frame.width-cell.bottomButton.frame.width)/2
            }
          }
        }
        if recognizer.state == UIGestureRecognizerState.ended { // check whether settings view should be animated
        print("ended")
        if location < cell.frame.width*dragCutoff {
//          tableView.scrollToRowAtIndexPath(tableView.indexPathForCell(cell)!,
//                                           atScrollPosition: UITableViewScrollPosition.Middle,
//                                           animated: true)
          UIView.animate(withDuration: 0.5, animations: {
            cell.contentView.frame.origin.x-=cell.frame.width
            self.currentSettingsView?.center.x = cell.center.x
            }, completion: {
              Void in
              print("Settings view kept")
              self.tableView.isScrollEnabled = false
              cell.contentView.isHidden = true
              self.inScrollView = false
              return
          })
          return
        }
          cell.contentView.alpha = 1
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            Void in
            
            cell.contentView.center.x = cell.center.x
            self.currentSettingsView?.frame.origin.x = cell.contentView.frame.maxX
            }, completion: {
              (value : Bool) in
              print("Settings view removed")
              self.inScrollView = true
              cell.contentView.isHidden = false
              self.currentSettingsView?.removeFromSuperview()
              self.currentSettingsView = nil
              self.currentCell = nil
              
              
          })
//          UIView.animate(withDuration: 0.5, animations: {
////            cell.contentView.alpha = 1
////            cell.contentView.center.x = cell.center.x
////            self.currentSettingsView?.frame.origin.x = cell.contentView.frame.maxX
//            }, completion: {
//              Void in
////              print("Settings view removed")
////              self.inScrollView = true
////              cell.contentView.isHidden = false
////              self.currentSettingsView?.removeFromSuperview()
////              self.currentSettingsView = nil
////              self.currentCell = nil
//              
//          })
      }
      }
    }
  }
  

  
  
  
  func transitionCellToScrollView(animated : Bool = true) {
    if let cell = currentCell {
      print("Cancelled")
      saveTasks()
      if animated {
        //executeButtonAnimation(cell, color: COLOR.settingsColor, location: cell.midButton.center)
        cell.executeFloodAnimation(atLocation: cell.midButton.center, withColor: COLOR.settingsColor)
      }
      cell.contentView.isHidden = false
        UIView.animate(withDuration: 0.8, animations: {
          self.currentMapView?.alpha = 0
          self.currentSettingsView?.alpha = 0
          
          cell.contentView.center.x = cell.center.x
          //self.currentSettingsView?.frame.origin.x+=(self.currentSettingsView!.frame.width)
          cell.alpha = 1
          }, completion: { Void in
            self.currentMapView?.removeFromSuperview()
            self.currentSettingsView?.removeFromSuperview()
            self.currentSettingsView = nil
            self.currentMapView = nil
            self.currentCell = nil
            self.tableView.isScrollEnabled = true
            self.inScrollView = true
        })
      
    }
  }
  
  // MARK: TableView
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CONSTANT.cellHeight
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    return tasks.count
    }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableTaskCell", for: indexPath) as? ReusableTaskCell
    {
          gestureRecognizer = UIPanGestureRecognizer(target: cell, action: #selector(ReusableTaskCell.panInView(_:)))
          gestureRecognizer.cancelsTouchesInView = true
          gestureRecognizer.delegate = cell
          cell.contentView.center = cell.center
          cell.bottomButton.addGestureRecognizer(gestureRecognizer)
          cell.contentView.addBorder(frame: genericCellInsideFrame, radius: CONSTANT.borderRadius)
          cell.nameLabel.text = tasks[(indexPath as NSIndexPath).row].name
          cell.delegate = self
          return cell
        }
        // Configure the cell...
      
      print("failed")
        return UITableViewCell()
    }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
  }

}

extension UIView {
  func addBorder(frame : CGRect, radius : CGFloat) {
    self.backgroundColor = UIColor.clear
    let whiteRoundedView : UIView = UIView(frame: frame)
    whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
    whiteRoundedView.layer.masksToBounds = false
    whiteRoundedView.layer.cornerRadius = radius
    whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
    whiteRoundedView.layer.shadowOpacity = 0.5
    self.addSubview(whiteRoundedView)
    self.sendSubview(toBack: whiteRoundedView)
  }
}


// Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }


/*
 // Override to support rearranging the table view.
 override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
