//
//  AllCertificaitonViewController.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 1/3/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit
import CoreData

class AllCertificaitonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var certification : [Certification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSFetchRequest<Certification>(entityName: "Certification")
        // Sorting the data coming back from core Data
        let sortDescriptor = NSSortDescriptor(key: "certificatedate", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let result = try PersistanceService.context.fetch(request)
            self.certification = result
        } catch {
            print("Couldn't fetch the data while loading")
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let request = NSFetchRequest<Certification>(entityName: "Certification")
        // Sorting the data coming back from core Data
        let sortDescriptor = NSSortDescriptor(key: "certificatedate", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let result = try PersistanceService.context.fetch(request)
            self.certification = result
        } catch {
            print("Couldn't fetch the data while loading")
        }
        tableView.reloadData()
    }
    
    // Table set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AllCertificateTableViewCell {

            // Date Label
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            if let myDate = certification[indexPath.row].certificatedate{
                let dateString = formatter.string(from: (myDate as Date))
                cell.certificateDateLabel.text = "\(dateString)"
            }
            cell.certificateTypeLabel.text = certification[indexPath.row].certificatetype
            cell.equipmentTypeLabel.text = certification[indexPath.row].equipment?.type
            cell.equipmentSerialNumberLabel.text = certification[indexPath.row].equipment?.serialNumer
            if let imageData = certification[indexPath.row].equipment?.image{
                let recoveredImage = UIImage(data: imageData as Data, scale: 0.5)
                cell.equipmentImageView.image = recoveredImage
                cell.equipmentImageView?.layer.cornerRadius = 40 //(recoveredImage?.size.width)! / 2
                cell.equipmentImageView.clipsToBounds = true
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let deletedObject = certification[indexPath.row]
            PersistanceService.context.delete(deletedObject)
            PersistanceService.saveContext()
            certification.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "certificateDetailFromCertificateTap" {
            let myIndex = tableView.indexPathForSelectedRow
            let vc = segue.destination as? CertificateDetailViewController
            if let index = myIndex{
                let value = certification[index.row]
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
