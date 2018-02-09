//
//  ViewController.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 12/26/17.
//  Copyright © 2017 mohammed al-batati. All rights reserved.
//

import UIKit
import CoreData

class EquipmentViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UISearchResultsUpdating{
    
    @IBOutlet weak var tableView: UITableView!
    
    var equipment : [EquipmentList] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredEquipment : [EquipmentList] = []
//    var equipmentList = ["Air Compressor","DAQ","Coflixp Basket","Flow Head Basket","Pipe Basket","BHS Kit","Burner","Centrifuge","Chemical Injection Pump","Coflixp Hose","Data Header","DWT","ESD","BOP ESD","Flanges","Flare line Basket","Flow Head","Forklift","Flare Stack","Ranarex","Gas Manifold","GSC","Gauge Carrier","Gauge Tank","Generator","Grease","Heating Jacket","Ignition System","Indirect Heater","Lab Cabin","Loading Gantry","Low Gas Meter","N2 Booster","Oil Manifold","OPC","PDC","Chart Recorder","Pressure Test Pump","RA Source","BOPSV","Separator","SCBA","Steam Generator","Water Bolier","Steam Exchanger","Stiff Joint","Storage Tank","Tank","SSV","Surge Tank","Trailer","Pump","Transfer Bench","Pump","Vacuum Pump"]
    
    // ViewDidLoad =======================================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting the SearchController===============
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        // Setting the Core data ====================
        let request = NSFetchRequest<EquipmentList>(entityName: "EquipmentList")
        // Sorting the data coming back from core Data
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        // let request : NSFetchRequest<EquipmentList> = EquipmentList.fetchRequest() // same as above
        do {
            let result = try PersistanceService.context.fetch(request)
            self.equipment = result
        } catch {
            print("Couldn't fetch the data while loading")
        }
        filteredEquipment = equipment
        tableView.reloadData()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let request = NSFetchRequest<EquipmentList>(entityName: "EquipmentList")
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let result = try PersistanceService.context.fetch(request)
            self.equipment = result
        } catch {
            print("Couldn't fetch the data while loading")
        }
        filteredEquipment = equipment
        navigationItem.title = "Equipment : \(filteredEquipment.count)"
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.dismiss(animated: false, completion: nil)
//        searchController.searchBar.text = ""
    }

    // Table ===========================================================================================================================
    
//    func numberOfSections(in tableView: UITableView) -> Int {
////        return equipmentList.count
//        var y = 0
//        var typeString = ""
//        for x in filteredEquipment{
//            if typeString == x.type{
//                continue
//            } else {
//                typeString = x.type!
//                y += 1
//            }
//        }
//        return y
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return equipment.count   //use the other to include the searching feature
        return filteredEquipment.count
//        return (filteredEquipment[section].type?.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EquipmentTableViewCell {
            cell.equipmentTypeLabel.text = filteredEquipment[indexPath.row].type
            cell.equipmentSNLabel.text = filteredEquipment[indexPath.row].serialNumer
            if let imageData = filteredEquipment[indexPath.row].image{
                let recoveredImage = UIImage(data: imageData as Data, scale: 0.5)
                cell.equipmentImageView.image = recoveredImage
                cell.equipmentImageView?.layer.cornerRadius = 35 //(recoveredImage?.size.width)! / 2
                cell.equipmentImageView.clipsToBounds = true
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredEquipment[section].type
    }
    
    // Deleteing a record ===================================================================================================================================
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { 

            let deletedObject = filteredEquipment[indexPath.row]
            PersistanceService.context.delete(deletedObject)
            PersistanceService.saveContext()
//            equipment.remove(at: indexPath.row)  // use the below line to include the searching feature
            filteredEquipment.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    

    // Segue to equipment details =========================================================================================================

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let mySelectedIndex = tableView.indexPathForSelectedRow
            let VC = segue.destination as? DetailViewController
                if let mySelection = mySelectedIndex {
//                    let value = equipment[mySelection.row]   // use the below line to include the searching feature
                    let value = filteredEquipment[mySelection.row]
                    VC?.type = value.type
                    VC?.assetCode = value.assetCode
                    VC?.bl = value.bl
                    VC?.bu = value.bu
                    VC?.aquireCost = value.aquireCost
                    VC?.locaiton = value.location
                    VC?.serialNumer = value.serialNumer
                    VC?.po = Int(value.po)
                    VC?.details = value.details
                    VC?.nbv = value.nbv
                    if value.image != nil {
                        if let recovredImage = UIImage(data: value.image! as Data, scale: 1.0){
                            VC?.recoveredImage = recovredImage
                        }
                    }else{
                        VC?.recoveredImage = #imageLiteral(resourceName: "tank2")
                    }
                }
        }
    }
    
    
    // Search results updating ==================================================================================================================
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text , !searchText.isEmpty{
            let LoweredCase = searchText.lowercased()
            filteredEquipment = equipment.filter({ (newEquipemnt) -> Bool in
                ///***************
                navigationItem.title = "Equipment : \(filteredEquipment.count)"
                return (newEquipemnt.type?.lowercased().contains(LoweredCase))!
            })
        } else {
            filteredEquipment = equipment
            navigationItem.title = "Equipment : \(filteredEquipment.count)"
        }
        
        tableView.reloadData()
    }


}


//            tableView.deleteRows(at: [indexPath], with: .fade)
//            let deletedObject = equipment[indexPath.row]  // use the below line to include the searching feature



// This commented code was before adding the search bar (Inside cellForRowAt **********************
//            cell.equipmentImageView.image = UIImage(named: "tank2")
// Use the other code to implemnet the search bar
//            cell.equipmentTypeLabel.text = equipment[indexPath.row].type
//            cell.equipmentSNLabel.text = equipment[indexPath.row].serialNumer
//            if let imageData = equipment[indexPath.row].image{
//                let recoveredImage = UIImage(data: imageData as Data, scale: 1.0)
//                cell.equipmentImageView.image = recoveredImage
//            }


//          Inside viewDidLoad
//        let newEquipment = EquipmentList(context: PersistanceService.context)
//        newEquipment.type = "Separator"
//        newEquipment.serialNumer = "U-24"
//        newEquipment.bu = "KIU"
//        newEquipment.bl = "SWT"
//        newEquipment.assetCode = "Httjddjjd"
//        newEquipment.details = "1440 psi separator"
//        newEquipment.po = 2343
//        newEquipment.aquireCost = 200_000
//        PersistanceService.saveContext()
//        equipment.append(newEquipment)
//        tableView.reloadData()


//        let request : NSFetchRequest<EquipmentList> = EquipmentList.fetchRequest() // same as above  used for fetch request


//    // Force touch functions ===========================================================================================================================
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        let previewView = storyboard?.instantiateViewController(withIdentifier: "EquipmentData")
//        return previewView
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        if let finalView = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") {
//            show(finalView, sender: self)
//        }
//
//    }

