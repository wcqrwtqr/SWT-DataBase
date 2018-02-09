//
//  ShowImageViewController.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 12/30/17.
//  Copyright © 2017 mohammed al-batati. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image : UIImage?
    var vcType : String?
    var vcSN : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Gesture set up ==========
        imageView.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(imagePinched(gesture:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(imagePan(gesture:)))
        imageView.addGestureRecognizer(pan)
        imageView.addGestureRecognizer(pinch)
        imageView.image = image
        navigationItem.title = "\(vcType ?? "N/A") : \(vcSN ?? "N/A")"
    }

    @objc func imagePan(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func imagePinched(gesture:UIPinchGestureRecognizer) {
        gesture.view?.transform = (gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale))!
        gesture.scale = 1.0
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let objectsToShare = [image ?? #imageLiteral(resourceName: "tank2")] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        //Excluded Activities
        activityVC.excludedActivityTypes = [UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = view
        self.present(activityVC, animated: true, completion: nil)
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





//        UIGraphicsBeginImageContext(view.frame.size)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let imageVV = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()

//        let textToShare = "Check out my app"
//
//        if let myWebsite = URL(string: "https://oilserv.sharepoint.com/ORBIS/SitePages/General/Home.aspx") {//Enter link to your app here
//            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "tank2")] as [Any]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//            //Excluded Activities
//            activityVC.excludedActivityTypes = [UIActivityType.addToReadingList]
//            //
//
//            activityVC.popoverPresentationController?.sourceView = view
//            self.present(activityVC, animated: true, completion: nil)
