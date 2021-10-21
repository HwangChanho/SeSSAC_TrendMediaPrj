//
//  MainTableViewCell.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    
    @IBOutlet var hashLabel: [UILabel]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var krTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var detailView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        linkButton.layer.cornerRadius = 15
        
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 15
        
        detailView.layer.cornerRadius = 10
        
        detailView.layer.shadowRadius = 10
        detailView.layer.shadowOffset = .zero
        detailView.layer.shadowOpacity = 0.1
        detailView.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
