//
//  CertificateDetailViewController.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 1/2/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit

class CertificateDetailViewController: UIViewController {

    @IBOutlet weak var inspectionDateTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var inspectionTypeTextField: UITextField!
    @IBOutlet weak var inspectionNotesTextField: UITextField!
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var inspectionImageView: UIImageView!

    
    var inspectionDate : Date?
    var expiryDate : Date?
    var inspectionType : String?
    var inspectionNotes : String?
    var uuid : String?
    var inspectionImage : UIImage?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the tap image gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        inspectionImageView.addGestureRecognizer(tapGesture)
        inspectionImageView.isUserInteractionEnabled = true
        
        // Setting up the labels/TextFields when loading
        inspectionTypeTextField.text = inspectionType
        inspectionNotesTextField.text = inspectionNotes
        // Image
        inspectionImageView.image = inspectionImage
        inspectionImageView.layer.cornerRadius = 100
        inspectionImageView.clipsToBounds = true
        // Date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        if let myDate = inspectionDate{
            let myCertificationDate = formatter.string(from: myDate as Date)
            inspectionDateTextField.text = myCertificationDate
            if let exp = expiryDate {
                let myCertificationExpiry = formatter.string(from: exp as Date)
                expiryDateTextField.text = myCertificationExpiry
                let today = Date()
                if exp > today{
                    expiryDateTextField.backgroundColor = UIColor.green
                }else {
                    expiryDateTextField.backgroundColor = UIColor.red
                }
            }
        }
        // UUID
        uuidTextField.text = uuid
        disableTextField(stat: false)
    }
    
    // Functions===========================================
    @objc func imageTapped(gesture: UITapGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let storyboarder = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboarder.instantiateViewController(withIdentifier: "showCertificate") as? ShowCertificateViewController{
                vc.inspectionImage = inspectionImage
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func disableTextField(stat: Bool) {
        if stat == false {
            inspectionDateTextField.isEnabled = false
            inspectionTypeTextField.isEnabled = false
            inspectionNotesTextField.isEnabled = false
            expiryDateTextField.isEnabled = false
            uuidTextField.isEnabled = false
        } else {
            inspectionDateTextField.isEnabled = true
            inspectionTypeTextField.isEnabled = true
            inspectionNotesTextField.isEnabled = true
            expiryDateTextField.isEnabled = true
            uuidTextField.isEnabled = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
