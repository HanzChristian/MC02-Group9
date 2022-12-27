//
//  StatisticsTableViewCell.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 20/12/22.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        

        // Initialization code
    }
    
    override func layoutSubviews() {
        resultLabel.textColor = magenta100
        
        backView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    func configureCell(title: String, result: String){
        
        titleLabel.text = title
        resultLabel.text = result
    }

}
