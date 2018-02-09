//
//  EquipmentTableViewCell.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 12/26/17.
//  Copyright © 2017 mohammed al-batati. All rights reserved.
//

import UIKit

class EquipmentTableViewCell: UITableViewCell {

    @IBOutlet weak var equipmentImageView: UIImageView!
    @IBOutlet weak var equipmentSNLabel: UILabel!
    @IBOutlet weak var equipmentTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
