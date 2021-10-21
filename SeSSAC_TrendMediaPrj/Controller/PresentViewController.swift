//
//  presentViewController.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/15.
//

import UIKit
import SwiftUI

class PresentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var castTableView: UITableView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    
    let tvManager = TvShowManager()
    
    override func viewDidLoad() {
        
        castTableView.delegate = self
        castTableView.dataSource = self
        
        let nibName = UINib(nibName: PresentTableViewCell.identifier, bundle: nil)
        castTableView.register(nibName, forCellReuseIdentifier: PresentTableViewCell.identifier)
        
        setUp()
    }
    
    func setUp() {
        searchView.backgroundColor = .gray
        
        xButton.imageView?.image = UIImage(systemName: "xmark.circle.fill")
        xButton.tintColor = .white
        
        searchButton.imageView?.image = UIImage(systemName: "magnifyingglass")
        searchButton.tintColor = .white
        
        textField.backgroundColor = .lightGray
        textField.textColor = .white
        textField.addLeftPadding(width: 25)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvManager.tvShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tvManager.tvShow[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PresentTableViewCell.identifier, for: indexPath) as? PresentTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = row.title
        cell.titleLabel.font = .boldSystemFont(ofSize: 15)
        
        cell.dateLabel.text = tvManager.dateFormats(date: row.releaseDate)
        cell.dateLabel.font = .systemFont(ofSize: 12)
        
        cell.contentLabel.text = row.overview
        cell.contentLabel.font = .systemFont(ofSize: 12)
        cell.contentLabel.textColor = .lightGray
        cell.contentLabel.numberOfLines = 3
        
        cell.mainImageView.image = UIImage(named: row.title)
        // cell.mainImageView.kf.setImage(with: url)
        cell.mainImageView.contentMode = .scaleToFill
        
        let background = UIView()

        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        
        return cell
    }
    
    // 셀의 높이 동적으로 설정
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        tableView.estimatedRowHeight = 20
//        tableView.rowHeight = UITableView.automaticDimension
//
//        return tableView.rowHeight
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension UITextField { // 왼쪽 값 패딩을 위해 사용
    func addLeftPadding(width: Double) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height)) // 간격
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always // 텍스트필드 왼쪽의 안 보이는 뷰를 나타내줌
  }
}
