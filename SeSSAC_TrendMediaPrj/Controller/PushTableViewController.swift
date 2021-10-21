//
//  PushTableViewController.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/19.
//

import UIKit
import Kingfisher

class PushViewController: UIViewController {
    
    static let identifier = "PushViewController"
        
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var showTableView: UITableView!
    
    var TvShow: TvShow?
    var boolSwitch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< MY MEDIA", style: .plain, target: self, action: #selector(closeButtonClicked(_:)))
        //navigationItem.title = "출연/제작"
        
        let url = URL(string: TvShow!.backdropImage)
        backgroundImageView.kf.setImage(with: url)
        backgroundImageView.contentMode = .scaleAspectFill
        
        posterImageView.image = UIImage(named: TvShow!.title)
        
        titleLabel.text = TvShow!.title
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        showTableView.delegate = self
        showTableView.dataSource = self
        
        let nibName = UINib(nibName: DetailTableViewCell.identifier, bundle: nil)
        showTableView.register(nibName, forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
    @objc func closeButtonClicked(_: Any) { // push 코드
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        if boolSwitch {
            boolSwitch = false
            showTableView.reloadData()
        } else {
            boolSwitch = true
            showTableView.reloadData()
        }
    }
}

extension PushViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
            
            if boolSwitch {
                cell.detailLabel.text = TvShow?.overview
                cell.detailLabel.numberOfLines = 1
                
                cell.detailButton.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
                cell.detailButton.setTitle("", for: .normal)
                cell.detailButton.tintColor = .black
            } else {
                cell.detailLabel.text = TvShow?.overview
                cell.detailLabel.numberOfLines = .max
                
                cell.detailButton.setImage(UIImage(systemName: "chevron.compact.up"), for: .normal)
                cell.detailButton.setTitle("", for: .normal)
                cell.detailButton.tintColor = .black
            }
            cell.detailButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") else { return UITableViewCell() }
            
            return cell
        }
    }
    
    // 셀의 높이 동적으로 설정
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            tableView.estimatedRowHeight = 500
            tableView.rowHeight = UITableView.automaticDimension

            return tableView.rowHeight
        } else {
            return 44
        }
    }
}
