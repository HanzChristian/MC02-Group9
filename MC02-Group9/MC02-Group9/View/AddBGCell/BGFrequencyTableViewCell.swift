//
//  BGFrequencyTableViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 11/10/22.
//

import UIKit

class BGFrequencyTableViewCell: UITableViewCell {

    @IBOutlet var bgFrequencyLbl:UILabel!
    @IBOutlet var bgFrequencyScheduleLbl:UILabel!
    @IBOutlet var bgFrequencyBtn:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
