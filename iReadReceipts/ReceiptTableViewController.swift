//
//  ReceiptTableViewController.swift
//  iReadReceipts
//
//  Created by Adam Kuniholm on 6/24/16.
//  Copyright © 2016 Adam Kuniholm. All rights reserved.
//

import UIKit

class ReceiptTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // MARK: Properties
  var masterList = [ReceiptItem]()
  var nameTextField : UITextField!
  var priceTextField : UITextField!
  var SKUTextField : UITextField!
  let imageAnalysisQueue = OperationQueue()
  var maxColorThreshold : Double = 100
  var minColorThreshold : Double = 10
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  @IBOutlet weak var settingsButton: UIBarButtonItem!
  var settingsButtonDragged = false
  
  // MARK: viewDidLoad
  override func viewDidLoad() {
    
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.backgroundColor = ReceiptItemCell().midRangeColor
    navigationController?.toolbar.isTranslucent = true
    navigationController?.hidesBarsWhenKeyboardAppears = true
    navigationController?.setToolbarHidden(false, animated: true)
//    if let settingsVC = settingsViewController {
//      self.addChildViewController(settingsVC)
//    }
    // Recognizers
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReceiptTableViewController.didInteractWithGesture(_:)))
    self.tableView.addGestureRecognizer(tapRecognizer)
    
    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ReceiptTableViewController.interactWithPan(_:)))
    navigationController?.navigationBar.addGestureRecognizer(panRecognizer)
    // Default List Items
    masterList.append(ReceiptItem(name: "Peanut Butter!", price: 5.35))
    masterList.append(ReceiptItem(name: "Peanut Butter!", price: 20.0))
    masterList.append(ReceiptItem(name: "Peanut Butter!", price: 70.0))
    masterList.append(ReceiptItem(name: "Peanut Paste!", price: 140))
    
    
  }
  
  // MARK: Photo Selection
  @IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
    let imagePickerActionSheet = UIAlertController(title: "add a receipt via photo", message: nil, preferredStyle: .actionSheet)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let cameraButton = UIAlertAction(title: "take photo", style: .default) { (alert) -> Void in
        let imagePicker = UIImagePickerController() // instantiate take photo
        imagePicker.delegate = self      // imagepicker is controlled by ReceiptTableVC
        imagePicker.sourceType = .camera // using camera as source
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
      }
      imagePickerActionSheet.addAction(cameraButton)
    }
    let fromLibraryButton = UIAlertAction(title: "choose existing", style: .default)
    { (alert) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .photoLibrary
      imagePicker.allowsEditing = true
      self.present(imagePicker, animated: true, completion: nil)
    }
    imagePickerActionSheet.addAction(fromLibraryButton)
    
    let cancelButton = UIAlertAction(title: "cancel", style: .cancel) {
      (alert) -> Void in }
    imagePickerActionSheet.addAction(cancelButton)
    present(imagePickerActionSheet, animated: true, completion: nil)
    
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: Image Manipulation
  func scaleImage(_ image: UIImage, maxDimension : CGFloat) -> UIImage {
    var scaledSize = CGSize(width: maxDimension, height: maxDimension)
    var scaleFactor: CGFloat
    
    if image.size.width > image.size.height {
      scaleFactor = image.size.height / image.size.width
      scaledSize.width = maxDimension
      scaledSize.height = scaledSize.width * scaleFactor
    } else {
      scaleFactor = image.size.width / image.size.height
      scaledSize.height = maxDimension
      scaledSize.width = scaledSize.height * scaleFactor
    }
    
    UIGraphicsBeginImageContext(scaledSize)
    image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return scaledImage!
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
    let scaledImage = scaleImage(selectedPhoto, maxDimension: 640) // find out why 640
    dismiss(animated: true, completion:  { self.analyzeImage(scaledImage) } )
  }
  // MARK: Tesseract!
  func analyzeImage(_ image: UIImage) {
    self.toggleActivityIndicator()
    self.tableView.isUserInteractionEnabled = false
    navigationController?.navigationBar.isUserInteractionEnabled = false
    imageAnalysisQueue.addOperation() {
      
      print("Started Tesseract...")
      let tesseract = G8Tesseract() // initialize tesseract
      print("Recognizing...")
      //let initTime = NSTimer()
    
      //activityIndicator.hidden = false
      tesseract.language = "eng+fra"
      tesseract.engineMode = .tesseractCubeCombined
      tesseract.pageSegmentationMode = .auto //  check this
      tesseract.maximumRecognitionTime = 60.0
      tesseract.image =  image.g8_blackAndWhite()
      tesseract.charWhitelist = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.-'/,;#$ \t \n"
      tesseract.recognize() // HEAVY LOAD HERE
      print("Recognized text:")
      if var result = tesseract.recognizedText {
        //print(result)
        self.parseTextData(&result)
        print(result)
      }
      self.toggleActivityIndicator()
      self.tableView.isUserInteractionEnabled = true
      self.navigationController?.navigationBar.isUserInteractionEnabled = true

    }
  }
  // Mark: Text Analysis
  func parseTextData(_ input : inout String) {
    var ind = input.startIndex
    while (ind != input.endIndex) {
      if (input.substring(from: ind) == ")" && input.substring(from: <#T##Collection corresponding to `ind`##Collection#>.index(before: ind)) == "(") {
        input.remove(at: <#T##Collection corresponding to `ind`##Collection#>.index(before: ind))
        input.replaceSubrange(ind...ind, with: "O")
      }
     ind = <#T##Collection corresponding to `ind`##Collection#>.index(ind, offsetBy: 1)
    }
  }
  // Mark: Interaction
  func toggleActivityIndicator(){
    if activityIndicator.isAnimating {
      print("Stopped Animating")
      activityIndicator.stopAnimating()
      return
    }
    print("Started Animating")
    activityIndicator.startAnimating()
    view.bringSubview(toFront: activityIndicator)
  }
  
  // MARK: Gestures
  func didInteractWithGesture(_ recognizer : UIGestureRecognizer){
    if recognizer.state != UIGestureRecognizerState.ended { return }
    let gestureLocation = recognizer.location(in: tableView)
    if let selectedCellIndexPath = tableView.indexPathForRow(at: gestureLocation) {
      if let selectedCell = tableView.cellForRow(at: selectedCellIndexPath) as? ReceiptItemCell {
      let accurateGestureLocation = recognizer.location(in: selectedCell)
      
      if selectedCell.nameLabel.frame.contains(accurateGestureLocation) {
        //print("Name label tapped!")
        selectedCell.selectField("Name")
        selectedCell.nameTextField.becomeFirstResponder()
        return
      }
        if selectedCell.priceLabel.frame.contains(accurateGestureLocation) {
          //print("Price label tapped!")
          selectedCell.selectField("Price")
          selectedCell.priceTextField.becomeFirstResponder()
          return
        }
        if selectedCell.SKULabel.frame.contains(accurateGestureLocation) {
          //print("SKU label tapped!")
          selectedCell.selectField("SKU")
          selectedCell.SKUTextField.becomeFirstResponder()
          return
        }
      }
    }
    tableView.reloadData()
  }

  func interactWithPan(_ pan : UIPanGestureRecognizer){
    //print("Location: \(pan.translationInView(self.navigationController?.navigationBar).y)")
    //print("Velocity: \(pan.velocityInView(self.navigationController?.navigationBar).y)")
    if pan.state == UIGestureRecognizerState.began {
      if let buttonView = settingsButton.value(forKey: "view") {
        if ((buttonView as AnyObject).frame).contains(pan.location(in: self.navigationController?.navigationBar)) {
          settingsButtonDragged = true
          print("Gesture started in settingsButton")
        }
        else  { settingsButtonDragged = false }
      }
      else { settingsButtonDragged = false }
    }
    if settingsButtonDragged {
      if pan.translation(in: navigationController?.view).y.truncatingRemainder(dividingBy: 10) == 0 {
      print(pan.translation(in: navigationController?.view).y)
      }
      if pan.translation(in: navigationController?.view).y.truncatingRemainder(dividingBy: 1) == 0 {
    
      }
    }
  }
  // MARK: TableView
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return masterList.count != 0 // allows changes to (deletion of) cells
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if !masterList.contains(masterList[indexPath.row]) { return } // cannot
    masterList.remove(at: indexPath.row)
    let cell = tableView.cellForRow(at: indexPath) as? ReceiptItemCell
    cell?.price = 0.00
    tableView.reloadData()
  }
 
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if masterList.count == 0 {  return 1  }
    return masterList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if masterList.count == 0 {
      tableView.isUserInteractionEnabled = false
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "ZeroCell", for: indexPath) as UITableViewCell
      cell.textLabel?.textAlignment = .center
      cell.textLabel?.highlightedTextColor = UIColor.white
      cell.isUserInteractionEnabled = false
      cell.textLabel?.text = "nothing to see here (yet!)"
      cell.backgroundColor = tableView.backgroundColor
      return cell
    }
    tableView.isUserInteractionEnabled = true
    if indexPath.row < masterList.count {
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "ReceiptItemCell", for: indexPath) as? ReceiptItemCell
      cell!.tableController = self
      cell!.name = masterList[indexPath.row].name
      cell!.price = masterList[indexPath.row].price
      if let cellSKU = masterList[indexPath.row].SKU {
          cell!.SKU = cellSKU
      }
      cell?.commit()
      cell?.canEdit = true
      cell?.labelView()      // make sure the labels are shown
      return cell!
    }
    return UITableViewCell()
  }
  
  @IBAction func addSingleItem(_ sender: UIBarButtonItem) {
    masterList.append(ReceiptItem(name: "Any Name", price: 0.99))
    if (masterList.count > 1) { self.title = "receipts (\(masterList.count))" }
    //tableView.reloadData()
  }
  
  func textFieldShouldReturn(_ userText: UITextField) -> Bool {
    navigationController?.setToolbarHidden(false, animated: true)
    navigationController?.setNavigationBarHidden(false, animated: true)
    userText.resignFirstResponder()
    return true
  }

}
