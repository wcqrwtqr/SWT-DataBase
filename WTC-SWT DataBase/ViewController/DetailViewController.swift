//
//  DetailViewController.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 12/28/17.
//  Copyright © 2017 mohammed al-batati. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var typeTextFied: UITextField!
    @IBOutlet weak var snTextFied: UITextField!
    @IBOutlet weak var assetCodeTextFied: UITextField!
    @IBOutlet weak var detailsTextFied: UITextField!
    @IBOutlet weak var buTextFied: UITextField!
    @IBOutlet weak var blTextFied: UITextField!
    @IBOutlet weak var locationTextFied: UITextField!
    @IBOutlet weak var poTextFied: UITextField!
    @IBOutlet weak var nbvTextFied: UITextField!
    @IBOutlet weak var costTextFied: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Vars
    let imagePicker = UIImagePickerController()
    var updatedArray : [EquipmentList] = []
    var imageData : NSData?
    var imageChanged : Bool = false
    
//    var equipmentDetails : [String : Any] = [:]
    var type : String?
    var serialNumer : String?
    var bu : String?
    var bl : String?
    var assetCode : String?
    var details : String?
    var nbv : Double?
    var po : Int?
    var aquireCost : Double?
    var locaiton : String?
    var recoveredImage : UIImage?
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        imageChanged = false
        // setting up the tap gestrue
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        // setting up the image Picker
        imagePicker.delegate = self
        //Setting up label/TextFields
        typeTextFied.text = type
        snTextFied.text = serialNumer
        assetCodeTextFied.text = assetCode
        detailsTextFied.text = details
        poTextFied.text = "\(po ?? 9999)"
        buTextFied.text = bu
        blTextFied.text = bl
        locationTextFied.text = locaiton
        costTextFied.text = "\(aquireCost ?? 9999)"
        nbvTextFied.text = "\(nbv ?? 9999)"
        if recoveredImage != nil {
            imageView.image = recoveredImage
            imageView.layer.cornerRadius = 75
            imageView.clipsToBounds = true
        }else{
            imageView.image = #imageLiteral(resourceName: "tank2")
        }
        disableTextField(stat: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        disableTextField(stat: false)
        imageChanged = false
    }

    // Update the data =============================================

    // MARK: - Buttons
    @IBAction func buttomBarUpdateTapped(_ sender: Any) {
        let request = NSFetchRequest<EquipmentList>(entityName: "EquipmentList")
        do {
            let results = try PersistanceService.context.fetch(request)
            for result in results {
                if let sn = result.value(forKey: "serialNumer") as? String{
                    if sn == serialNumer {
                        result.setValue(snTextFied.text, forKey: "serialNumer")
                        result.setValue(typeTextFied.text, forKey: "type")
                        if let myCost = Double(costTextFied.text!){
                            result.setValue(myCost, forKey: "aquireCost")
                        }
                        result.setValue(assetCodeTextFied.text, forKey: "assetCode")
                        result.setValue(locationTextFied.text, forKey: "location")
                        result.setValue(blTextFied.text, forKey: "bl")
                        result.setValue(buTextFied.text, forKey: "bu")
                        result.setValue(detailsTextFied.text, forKey: "details")
                        // Checking if image changed or not
                        if imageChanged == true{
                            result.setValue(imageData, forKey: "image")
                        }
                        if let myNBV = Double(nbvTextFied.text!){
                            result.setValue(myNBV, forKey: "nbv")
                        }
                        if let myPO = Int(poTextFied.text!) {
                            result.setValue(myPO, forKey: "po")
                        }
                        PersistanceService.saveContext()
                    }
                }
            }
        } catch {
            print("Couldn't fetch the data while loading")
        }
        
        // showing alerts
        let alert = UIAlertController(title: "Updated", message: "The data has been Updated", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Buttons
    // Buttons ==========================================================================================
    
    @IBAction func buttomBarEditTapped(_ sender: Any) {
        if poTextFied.isEnabled == true {
            disableTextField(stat: false)
        } else{
            disableTextField(stat: true)
        }
    }

    @IBAction func cameraTapped(_ sender: Any) {
        if typeTextFied.isEnabled == true {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }else {
            alerting(issueTitle: "Edit Disabled", issueMessage: "You need to enable editing first")
        }

    }
    
    @IBAction func photoLibraryTapped(_ sender: Any) {
        if typeTextFied.isEnabled == true{
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }else{
            alerting(issueTitle: "Edit Disabled", issueMessage: "You need to enable editing first")
        }
    }
    
    // MARK: - Functions
    // Picking Image =============================================
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
            prepareImageForSaving(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    // Process the image for saving =============================================
    func prepareImageForSaving(image:UIImage) {
        guard let imageDataa = UIImageJPEGRepresentation(image, 1.0) as NSData? else {
            print("Error JPG")
            return}
        self.imageData = imageDataa
        imageChanged = true
    }
    
    func alerting(issueTitle : String , issueMessage : String) {
        let alert = UIAlertController(title: issueTitle, message: issueMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Tapping the Image =============================================
    
    @objc func imageTapped(gesture : UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let stroyboardy = UIStoryboard.init(name: "Main", bundle: nil)
            if let VC = stroyboardy.instantiateViewController(withIdentifier: "showimage") as? ShowImageViewController {
                VC.image = recoveredImage
                VC.vcType = type
                VC.vcSN = serialNumer
                navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func disableTextField(stat: Bool) {
        if stat == false {
            typeTextFied.isEnabled = false
            snTextFied.isEnabled = false
            poTextFied.isEnabled = false
            assetCodeTextFied.isEnabled = false
            blTextFied.isEnabled = false
            buTextFied.isEnabled = false
            detailsTextFied.isEnabled = false
            locationTextFied.isEnabled = false
            costTextFied.isEnabled = false
            nbvTextFied.isEnabled = false
            navigationItem.title = "Details"
        } else {
            typeTextFied.isEnabled = true
            snTextFied.isEnabled = true
            poTextFied.isEnabled = true
            assetCodeTextFied.isEnabled = true
            blTextFied.isEnabled = true
            buTextFied.isEnabled = true
            detailsTextFied.isEnabled = true
            locationTextFied.isEnabled = true
            costTextFied.isEnabled = true
            nbvTextFied.isEnabled = true
            navigationItem.title = "Edit"
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addnewcertificatesegue" {
            if let vc = segue.destination as? AddCertificateViewController{
                vc.equipmentTypeValue = type
                vc.equipmentSNValue = serialNumer
            }
        }
        if segue.identifier == "ShowCertification" {
            if let vc = segue.destination as? CertificationTableViewController {
                vc.mySerialNumber = serialNumer
            }
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
