//
//  AddCertificateViewController.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 12/31/17.
//  Copyright © 2017 mohammed al-batati. All rights reserved.
//

import UIKit
import CoreData

class AddCertificateViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var equipmentType: UITextField!
    @IBOutlet weak var equipmentSN: UITextField!
    @IBOutlet weak var certificateTypeTextField: UITextField!
    @IBOutlet weak var certificateDateTextField: UITextField!
    @IBOutlet weak var certificateNotesTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var equipmentTypeValue : String?
    var equipmentSNValue : String?
    var certificateTypeList  = ["MPI","UTM","Pressure Test","MS-1","MS-2","MS-3","MS-4","Load Test","Other"]
    var certificateDate : Date?
    var certificateType : String?
    var certificateNotes : String?
    var certificateExpiry : Date?
    var certificateFile : NSData?
    var id : UUID?
    var duration = 0
    
    
    let certificatePicker = UIPickerView()
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Sort the array
        let sortedArray = certificateTypeList.sorted()
        certificateTypeList = sortedArray
        // Setting the date Picker
        equipmentSN.isEnabled = false
        equipmentType.isEnabled = false
        equipmentType.text = equipmentTypeValue
        equipmentSN.text = equipmentSNValue
        createDatePicker()
        // Setting the list picker view
        certificateTypeTextField.inputView = certificatePicker
        certificatePicker.delegate = self
        certificatePicker.dataSource = self
        // Setting the image picker
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }

    func createDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBar = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneBar], animated: false)
        certificateDateTextField.inputAccessoryView = toolBar
        certificateDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    //Mark:- Buttons
    @objc func donePressed (){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        certificateDateTextField.text = "\(dateString)"
        certificateDate = datePicker.date
        self.view.endEditing(true)
        print(certificateDate!)
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        let request = NSFetchRequest<EquipmentList>.init(entityName: "EquipmentList")
//        let myEquipment = EquipmentList(context: PersistanceService.context)
        do {
            let results = try PersistanceService.context.fetch(request)
            for result in results{
                if let mySN = result.value(forKey: "SerialNumer") as? String{
                    if let myType = result.value(forKey: "type") as? String{
                        if mySN == equipmentSNValue && myType == equipmentTypeValue {
                            let myCertificate = Certification(context: PersistanceService.context)
//                            myCertificate.certificatedate = datePicker.date as? NSDate
                            myCertificate.certificatetype = certificateTypeTextField.text
                            myCertificate.certificatenotes = certificateNotesTextField.text
                            if let myPickedDate = datePicker.date as? NSDate {
                                myCertificate.certificatedate = myPickedDate
                            }
                            if certificateFile != nil {
                                myCertificate.certificatefile = certificateFile
                            } else {
                                if let defaultThumb = UIImageJPEGRepresentation(#imageLiteral(resourceName: "tank2"), 0.4) as NSData?{
                                    myCertificate.certificatefile = defaultThumb
                                }
                            }
                            var datecomponent = DateComponents()
                            if certificateTypeTextField.text == "MS-1"{
                                duration = 3
                            } else if certificateTypeTextField.text == "MS-2" || certificateTypeTextField.text == "MPI"{
                                duration = 6
                            }else if certificateTypeTextField.text == "MS-4"{
                                duration = 60
                            }else {
                                duration = 12
                            }
                            datecomponent.month = duration
                            certificateExpiry = Calendar.current.date(byAdding: datecomponent, to: certificateDate!)
                            myCertificate.certificateexpiry = certificateExpiry as NSDate?
                            
                            let uuid = UUID()
                            myCertificate.id = uuid
                            print(uuid)
                            
                            result.addToCertificate(myCertificate)
                            PersistanceService.saveContext()
                        }
                    }
                }
            }
        } catch  {
            fatalError("Could not find the data for certification")
        }
        
        let alert = UIAlertController(title: "Saved", message: "Certificate was saved to Core Data", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alert) in
            for vc in (self.navigationController?.viewControllers ?? []) {
                if vc is DetailViewController{
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Photo button
    @IBAction func photoButtonTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Camera Button
    @IBAction func camerButtonTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = imagePicked
            prepareImageForSaving(image: imagePicked)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func prepareImageForSaving(image : UIImage) {
        if let imageData = UIImageJPEGRepresentation(image, 1.0) as NSData?{
            certificateFile = imageData
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Picker
    // Picker view for the Certificate List==========================================================================
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return certificateTypeList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return certificateTypeList[row]
//        return sortedArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        certificateTypeTextField.text = certificateTypeList[row]
//        certificateTypeTextField.resignFirstResponder()
    }
    
    
//    func alerting(issueTitle : String , issueMessage : String) {
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
