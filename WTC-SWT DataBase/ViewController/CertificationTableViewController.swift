//
//  CertificationTableViewController.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 1/1/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit
import CoreData

class CertificationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var mySerialNumber : String?
    var certificate : [Certification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        certificate = []
        let request = NSFetchRequest<Certification>.init(entityName: "Certification")
        let sortDescriptor = NSSortDescriptor(key: "certificatedate", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try PersistanceService.context.fetch(request)
            for result in results{
                if result.equipment?.serialNumer == mySerialNumber{
                    if result.certificatedate != nil{
                        self.certificate.append(result)
                    }
                }
            }
        } catch {
            print("Couldn't fetch the data while loading")
        }
        tableView.reloadData()
        if certificate.count == 0 {
            alerting(issueTitle: "No Certificates", issueMessage: "There is no certfication for this eqiupment")
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certificate.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CertificateTableViewCell {
            
            // Date Label
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            if let myDate = certificate[indexPath.row].certificatedate{
                let dateString = formatter.string(from: (myDate as Date))
                cell.dateCreatedCellLabel.text = dateString
            }
            // Type Label
            cell.typeCellLabel.text = certificate[indexPath.row].certificatetype
            // Image Lable
            if let imageData = certificate[indexPath.row].certificatefile{
                let recoveredImager = UIImage(data: imageData as Data, scale: 0.5)
                cell.imageViewCell.image = recoveredImager
                cell.imageViewCell?.layer.cornerRadius = 35
                cell.imageViewCell.clipsToBounds = true
            }
            // printing the UUID
            let myUUID = (certificate[indexPath.row].id)?.description
            cell.uuidLabel.text = myUUID
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let deletedObject = certificate[indexPath.row]
            PersistanceService.context.delete(deletedObject)
            certificate.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func alerting(issueTitle : String , issueMessage : String) {
        let alert = UIAlertController(title: issueTitle, message: issueMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCertificateDetails" {
            let myIndex = tableView.indexPathForSelectedRow
            let vc = segue.destination as? CertificateDetailViewController
            if let index = myIndex{
                let value = certificate[index.row]
                vc?.inspectionNotes = value.certificatenotes
                vc?.inspectionType = value.certificatetype
                // Image
                if value.certificatefile != nil {
                    if let recovredImage = UIImage(data: value.certificatefile! as Data, scale: 1.0){
                        vc?.inspectionImage = recovredImage
                    }
                }else{
                    vc?.inspectionImage = #imageLiteral(resourceName: "tank2")
                }
                // Dates
                vc?.inspectionDate = value.certificatedate as Date?
                vc?.expiryDate = value.certificateexpiry as Date?
                // UUID
                vc?.uuid = value.id?.description
            }
        }
    }
  

}
