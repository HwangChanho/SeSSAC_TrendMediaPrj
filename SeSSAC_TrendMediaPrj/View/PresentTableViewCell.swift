//
//  presentTableViewCell.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/18.
//

import UIKit

class PresentTableViewCell: UITableViewCell {
    
    static let identifier = "PresentTableViewCell"
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .darkGray
        
        titleLabel.backgroundColor = .darkGray
        titleLabel.textColor = .white
        dateLabel.backgroundColor = .darkGray
        dateLabel.textColor = .white
        contentLabel.backgroundColor = .darkGray
        contentLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
