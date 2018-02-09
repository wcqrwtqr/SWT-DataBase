//
//  CertificateTableViewCell.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 1/1/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit

class CertificateTableViewCell: UITableViewCell {

    
    @IBOutlet weak var typeCellLabel: UILabel!
    @IBOutlet weak var dateCreatedCellLabel: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var uuidLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
