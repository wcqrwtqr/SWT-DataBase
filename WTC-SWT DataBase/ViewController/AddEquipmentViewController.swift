//
//  AddEquipmentViewController.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 12/27/17.
//  Copyright © 2017 mohammed al-batati. All rights reserved.
//

import UIKit
import AVFoundation

class AddEquipmentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AVCaptureMetadataOutputObjectsDelegate {


    // For QR
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    //For reading QR
    var qrReadString : String?

    //MARK:- Outlets
    @IBOutlet weak var typeLabel: UITextField!
    @IBOutlet weak var serialNumberLabel: UITextField!
    @IBOutlet weak var nvbLabel: UITextField!
    @IBOutlet weak var assetCodeLabel: UITextField!
    @IBOutlet weak var detailsLabel: UITextField!
    @IBOutlet weak var buLabel: UITextField!
    @IBOutlet weak var blLabel: UITextField!
    @IBOutlet weak var costLabel: UITextField!
    @IBOutlet weak var poLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    //MARK:- Var
    let imagePicker = UIImagePickerController()
    var imageData : NSData?
    let equipmentPicker = UIPickerView()
    var equipmentList = ["Air Compressor","DAQ","Coflixp Basket","Flow Head Basket","Pipe Basket","BHS Kit","Burner","Centrifuge","Chemical Injection Pump","Coflixp Hose","Data Header","DWT","ESD","BOP ESD","Flanges","Flare line Basket","Flow Head","Forklift","Flare Stack","Ranarex","Gas Manifold","GSC","Gauge Carrier","Gauge Tank","Generator","Grease","Heating Jacket","Ignition System","Indirect Heater","Lab Cabin","Loading Gantry","Low Gas Meter","N2 Booster","Oil Manifold","OPC","PDC","Chart Recorder","Pressure Test Pump","RA Source","BOPSV","Separator","SCBA","Steam Generator","Water Bolier","Steam Exchanger","Stiff Joint","Storage Tank","Tank","SSV","Surge Tank","Trailer","Pump","Transfer Bench","Pump","Vacuum Pump"]

    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sorting the list
        let sortedEquipment = equipmentList.sorted()
        equipmentList = sortedEquipment
        // Setting Equipment list picker
        typeLabel.inputView = equipmentPicker
        equipmentPicker.delegate = self
        equipmentPicker.dataSource = self
        // Setting Image Picker
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    //MARK:- Buttons
   // Adding equipment ==============================================================================
    
    @IBAction func addNewTapped(_ sender: Any) {
        if typeLabel.text != "" && serialNumberLabel.text != "" && assetCodeLabel.text != "" {

            let newEquipment = EquipmentList(context: PersistanceService.context)
            newEquipment.type = typeLabel.text ?? "N/A Type"
            newEquipment.serialNumer = serialNumberLabel.text ?? "N/A Serial Number"
            newEquipment.bu = buLabel.text ?? "KIU"
            newEquipment.bl = blLabel.text ?? "SWT"
            newEquipment.assetCode = assetCodeLabel.text ?? "N/A Asset Code"
            newEquipment.details = detailsLabel.text ?? "N/A Details"
            newEquipment.location = locationLabel.text ?? "N/A Location"
            if let myNBV = nvbLabel.text {
                newEquipment.nbv = Double(myNBV) ?? 9999.99
            }
            if let myPO = poLabel.text {
                newEquipment.po = Int16(myPO) ?? 9999
            }
            if let myCost = costLabel.text {
                newEquipment.aquireCost = Double(myCost) ?? 99999.99
            }
            if imageData != nil{
                newEquipment.image = imageData
            } else {
                if let defaultThumb = UIImageJPEGRepresentation(#imageLiteral(resourceName: "tank2"), 0.4) as NSData?{
                    newEquipment.image = defaultThumb
                }
            }
            PersistanceService.saveContext()
            
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            alerting(issueTitle: "Missing Field", issueMessage: "You need to fill all required fields")
        }
    }
    // Camera button
    @IBAction func cameraButtonTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    // Library Button
    @IBAction func photoLibraryButtonTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    // QR Code button
    
    @IBAction func qrScanTapped(_ sender: Any) {
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.qr]
        } else {
            failed()
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    //MARK:- Functions

    // QR Functions
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue!);
        }
        dismiss(animated: true)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func found(code: String) {
//        print(code)
        qrReadString = code
        
        if let equipmentArray = qrReadString?.components(separatedBy: "//"){
            print(equipmentArray)
            if equipmentArray.count == 10 {
                typeLabel.text = equipmentArray[0]
                serialNumberLabel.text = equipmentArray[1]
                nvbLabel.text = equipmentArray[8]
                assetCodeLabel.text = equipmentArray[4]
                detailsLabel.text = equipmentArray[6]
                buLabel.text = equipmentArray[2]
                blLabel.text = equipmentArray[3]
                costLabel.text = equipmentArray[7]
                poLabel.text = equipmentArray[5]
                locationLabel.text = equipmentArray[9]
                
                // Make the saving automatic
                let newEquipment = EquipmentList(context: PersistanceService.context)
                newEquipment.type = typeLabel.text ?? "N/A Type"
                newEquipment.serialNumer = serialNumberLabel.text ?? "N/A Serial Number"
                newEquipment.bu = buLabel.text ?? "KIU"
                newEquipment.bl = blLabel.text ?? "SWT"
                newEquipment.assetCode = assetCodeLabel.text ?? "N/A Asset Code"
                newEquipment.details = detailsLabel.text ?? "N/A Details"
                newEquipment.location = locationLabel.text ?? "N/A Location"
                if let myNBV = nvbLabel.text {
                    newEquipment.nbv = Double(myNBV) ?? 9999.99
                }
                if let myPO = poLabel.text {
                    newEquipment.po = Int16(myPO) ?? 9999
                }
                if let myCost = costLabel.text {
                    newEquipment.aquireCost = Double(myCost) ?? 99999.99
                }
                if let defaultThumb = UIImageJPEGRepresentation(#imageLiteral(resourceName: "tank2"), 0.4) as NSData?{
                    newEquipment.image = defaultThumb
                }
                PersistanceService.saveContext()
                
            } else{
                captureSession.stopRunning()
                previewLayer.removeFromSuperlayer()
                alerting(issueTitle: "QR not supported", issueMessage: "This QR is not supported")
//                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        captureSession.stopRunning()
        previewLayer.removeFromSuperlayer()
//        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.popViewController(animated: true)

    }
    
    // Alerting controller =====
    func alerting(issueTitle : String , issueMessage : String) {
        let alert = UIAlertController(title: issueTitle, message: issueMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // Image processing for saving to core data =======
    func prepareImageForSaving(image:UIImage) {
        guard let imageDataa = UIImageJPEGRepresentation(image, 1.0) as NSData? else {
            print("Error JPG")
            return}
        self.imageData = imageDataa
    }
    
    // Dismiss keyboard =============================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // Image Picking =============================================
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = imagePicked
            prepareImageForSaving(image: imagePicked)
        }
        dismiss(animated: true, completion: nil)
    }
    //MARK:- Picker Set up
    // Setting Up Data Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return equipmentList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return equipmentList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeLabel.text = equipmentList[row]
    }
    
}


