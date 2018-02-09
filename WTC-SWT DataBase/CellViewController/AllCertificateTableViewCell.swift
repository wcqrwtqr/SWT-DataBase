//
//  AllCertificateTableViewCell.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 1/3/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit

class AllCertificateTableViewCell: UITableViewCell {

    
   
    @IBOutlet weak var equipmentTypeLabel: UILabel!
    @IBOutlet weak var equipmentSerialNumberLabel: UILabel!
    @IBOutlet weak var certificateTypeLabel: UILabel!
    @IBOutlet weak var certificateDateLabel: UILabel!
    @IBOutlet weak var equipmentImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
