//
//  presentViewController.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/15.
//

import UIKit
import SwiftUI
import Alamofire
import SwiftyJSON
import Kingfisher

class PresentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {

    var movieData: [Movie] = []

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var castTableView: UITableView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    
    var startPage = 1
    var totalCount = 2138
    
    override func viewDidLoad() {
        
        castTableView.delegate = self
        castTableView.dataSource = self
        castTableView.prefetchDataSource = self // 프로토콜이기 떄문에 연결 해줘야 한다.
        let nibName = UINib(nibName: PresentTableViewCell.identifier, bundle: nil)
        castTableView.register(nibName, forCellReuseIdentifier: PresentTableViewCell.identifier)
        
        setUp()
        fetchMovieData()
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
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        fetchMovieData()
    }
    
    // 네이버 영화 네트워크 통신
    func fetchMovieData() {
        if let query = "사랑".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let url = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&display=10&start=\(startPage)"
            let header: HTTPHeaders = [
                "X-Naver-Client-Id": APIKey.NAVER_ID,
                "X-Naver-Client-Secret": APIKey.NAVER_SECRET
            ]
            
            AF.request(url, method: .get, headers: header).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    // print("JSON: \(json)")
                    
                    self.totalCount = json["items"]["totalcount"].intValue
                    
                    for item in json["items"].arrayValue { // 옵셔널에 대한 처리가 싫을떄는 array로
                        let value = item["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                        let imageValue = item["image"].stringValue
                        let linkValue = item["link"].stringValue
                        let userRating = item["userRating"].stringValue
                        let sub = item["subtitle"].stringValue
                        
                        let data = Movie(titleData: value, imageData: imageValue, linkDate: linkValue, userRatingData: userRating, subtitle: sub)
                        
                        self.movieData.append(data)
                    }
                    
                    self.castTableView.reloadData() // 중요
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = movieData[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PresentTableViewCell.identifier, for: indexPath) as? PresentTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = row.titleData
        cell.titleLabel.font = .boldSystemFont(ofSize: 15)
        
        cell.dateLabel.text = row.subtitle
        cell.dateLabel.font = .systemFont(ofSize: 12)
        
        cell.contentLabel.text = row.userRatingData
        cell.contentLabel.font = .systemFont(ofSize: 12)
        cell.contentLabel.textColor = .lightGray
        cell.contentLabel.numberOfLines = 3
        
        if let url = URL(string: row.imageData) {
            cell.mainImageView.kf.setImage(with: url)
        } else {
            cell.mainImageView.image = UIImage(systemName: "star")
        }
        cell.mainImageView.contentMode = .scaleToFill
        
        let background = UIView()

        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    // 셀이 화면에 보이기 전에 필요한 리소스를 미리 다운 받는 기능
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieData.count - 1 == indexPath.row {
                startPage += 10
                fetchMovieData()
                print("indexPath: \(indexPath)")
                // 서버에 요청
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("취소 : \(indexPaths)")
    }
}

extension UITextField { // 왼쪽 값 패딩을 위해 사용
    func addLeftPadding(width: Double) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height)) // 간격
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always // 텍스트필드 왼쪽의 안 보이는 뷰를 나타내줌
  }
}
