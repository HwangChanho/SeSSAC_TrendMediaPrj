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
    
    var tmdbMovie: TMDBMovie?
    var crditArr: [Credit] = []
    
    var boolSwitch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< MY MEDIA", style: .plain, target: self, action: #selector(closeButtonClicked(_:)))
        //navigationItem.title = "출연/제작"
        
        let url = URL(string: "\(Endpoint.tmdbImageURL)w300\(tmdbMovie!.backdropPath)")
        backgroundImageView.kf.setImage(with: url)
        backgroundImageView.contentMode = .scaleAspectFill
        
        let url2 = URL(string: "\(Endpoint.tmdbImageURL)w300\(tmdbMovie!.posterPath)")
        posterImageView.kf.setImage(with: url2)
        
        titleLabel.text = tmdbMovie!.title
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        showTableView.delegate = self
        showTableView.dataSource = self
        showTableView.prefetchDataSource = self
        
        let nibName = UINib(nibName: DetailTableViewCell.identifier, bundle: nil)
        showTableView.register(nibName, forCellReuseIdentifier: DetailTableViewCell.identifier)
        
        loadCreditData(movieId: tmdbMovie!.movieId)
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
    
    func loadCreditData(movieId: Int) {
        print(#function)
        
        TMDBAPIManager.shared.getCreditDataDemo(movieId: movieId, mediaOpt: "movie") { code, json in
            print(code)
            
            switch code {
            case 200:
                for cast in json["cast"].arrayValue {
                    let character = cast["character"].stringValue
                    let gender = cast["gender"].intValue
                    let name = cast["name"].stringValue
                    let profilePath = cast["profile_path"].stringValue
                    
                    let data = Credit(character: character, gender: gender, name: name, profilePath: profilePath)
                    
                    self.crditArr.append(data)
                }
                
                self.showTableView.reloadData()
            default:
                print(code)
            }
        }
    }
}

extension PushViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crditArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
            
            if boolSwitch {
                cell.detailLabel.text = tmdbMovie?.overview
                cell.detailLabel.numberOfLines = 1
                
                cell.detailButton.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
                cell.detailButton.setTitle("", for: .normal)
                cell.detailButton.tintColor = .black
            } else {
                cell.detailLabel.text = tmdbMovie?.overview
                cell.detailLabel.numberOfLines = .max
                
                cell.detailButton.setImage(UIImage(systemName: "chevron.compact.up"), for: .normal)
                cell.detailButton.setTitle("", for: .normal)
                cell.detailButton.tintColor = .black
            }
            cell.detailButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") else { return UITableViewCell() }
            
            let row = crditArr[indexPath.row - 1]
            
            let titleLabel = cell.viewWithTag(1000) as! UILabel
            let subTitleLabel = cell.viewWithTag(1001) as! UILabel
            
            if let image = cell.viewWithTag(1002) as? UIImageView {
                if let url = URL(string: "\(Endpoint.tmdbImageURL)w300\(row.profilePath)") {
                    image.kf.setImage(with: url)
                } else {
                    image.image = UIImage(systemName: "star")
                }
            } else {
                print("no image")
            }
            
            titleLabel.text = row.character
            subTitleLabel.text = row.name
            
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
    
    // 셀이 화면에 보이기 전에 필요한 리소스를 미리 다운 받는 기능
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("취소 : \(indexPaths)")
    }
}
