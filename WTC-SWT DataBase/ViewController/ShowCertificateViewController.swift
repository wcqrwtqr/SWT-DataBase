//
//  ShowCertificateViewController.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 1/3/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit

class ShowCertificateViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var inspectionImage : UIImage?
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the gestures
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(imagePinch(gesture:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(imagePan(gesture:)))
//        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(imageRotation(gesture:)))
        imageView.addGestureRecognizer(pan)
        imageView.addGestureRecognizer(pinch)
//        imageView.addGestureRecognizer(rotate)
        imageView.isUserInteractionEnabled = true
        // Setting the image
        imageView.image = inspectionImage
        
    }

    // MARK: - Functions
    @objc func imagePan(gesture : UIPanGestureRecognizer) {
        let transulation = gesture.translation(in: self.view)
        imageView.center = CGPoint(x: imageView.center.x + transulation.x, y: imageView.center.y + transulation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
    // TODO
//    @objc func imageRotation(gesture : UIRotationGestureRecognizer){
//        gesture.view?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//    }
    
    @objc func imagePinch(gesture : UIPinchGestureRecognizer) {
        gesture.view?.transform = (gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale))!
        gesture.scale = 1.0
    }
    
    
    // MARK: - Buttons

    @IBAction func shareButtonTapped(_ sender: Any) {
        let objectsToShare = [inspectionImage ?? #imageLiteral(resourceName: "tank2")] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        //Excluded Activities
        activityVC.excludedActivityTypes = [UIActivityType.addToReadingList]
        // Show the popOver
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
