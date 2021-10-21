//
//  ViewController.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/15.
//

import Kingfisher
import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainBannerImage: UIImageView!
    @IBOutlet weak var buttonPalletView: UIView!
    @IBOutlet weak var castTableView: UITableView!
    
    @IBOutlet weak var bookButton: UIButton!
    
    static let identifier = "MainViewController"
    let tvManager = TvShowManager()
    
    var tvShowTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castTableView.delegate = self
        castTableView.dataSource = self
        
        let nibName = UINib(nibName: MainTableViewCell.identifier, bundle: nil)
        castTableView.register(nibName, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        navigationItem.title = "TREND MEDIA"
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(glassButtonClicked(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(menuButtonClicked(_:)))
        
        setup()
    }
    
    func setup() {
        mainBannerImage.backgroundColor = .black
        
        buttonPalletView.backgroundColor = .orange
        buttonPalletView.layer.cornerRadius = 10
        
        buttonPalletView.layer.shadowRadius = 10
        buttonPalletView.layer.shadowOffset = .zero
        buttonPalletView.layer.shadowOpacity = 0.5
        buttonPalletView.layer.shadowColor = UIColor.black.cgColor
        buttonPalletView.layer.shadowPath = UIBezierPath(rect: buttonPalletView.bounds).cgPath
        
        bookButton.addTarget(self, action: #selector(bookButtonPressed(_:)), for: .touchUpInside)
    }
    
    @IBAction func movieButtonPressed(_ sender: UIButton) {
        // 1. 스토리보드 특정
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // 2. 스토리보드 내 많은 뷰 컨트롤러 중 전환하고자 하는 뷰컨트롤러 가저오기
        // 동일 스토리뷰일떄
        let vc = storyBoard.instantiateViewController(withIdentifier: MovieViewController.identifier) as! MovieViewController // 강제해제 연산자를 통해 매칭
        
        // Push: 스토리보드에서 네비게이션 컨트롤러가 임베드 되어 있는 지 확인!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func bookButtonPressed(_ sender: UIButton) {
        // 1. 스토리보드 특정
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // 2. 스토리보드 내 많은 뷰 컨트롤러 중 전환하고자 하는 뷰컨트롤러 가저오기
        // 동일 스토리뷰일떄
        let vc = storyBoard.instantiateViewController(withIdentifier: BookViewController.identifier) as! BookViewController // 강제해제 연산자를 통해 매칭
        
        // Push: 스토리보드에서 네비게이션 컨트롤러가 임베드 되어 있는 지 확인!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func glassButtonClicked(_: Any) { // present 코드
        // 1. 스토리보드 특정
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // 2. 스토리보드 내 많은 뷰 컨트롤러 중 전환하고자 하는 뷰컨트롤러 가저오기
        let vc = storyBoard.instantiateViewController(withIdentifier: "PresentViewController") as! PresentViewController// 강제해제 연산자를 통해 매칭
        
        // 2-1. 네비게이션 컨트롤러 임베드
        let nav = UINavigationController(rootViewController: vc)
        
        // 옵션
        // vc.modalTransitionStyle = .partialCurl
        nav.modalPresentationStyle = .fullScreen
        
        // 3. present
        present(nav, animated: true, completion: nil)
    }
    
    @objc func menuButtonClicked(_: Any) {
        print("clicked")
    }
    
    // 셀의 갯수: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvManager.tvShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        let row = tvManager.tvShow[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        let url = URL(string: row.backdropImage)
        
        cell.titleLabel.text = row.title
        cell.titleLabel.font = .boldSystemFont(ofSize: 20)
        
        cell.mainImageView.kf.setImage(with: url)
        cell.mainImageView.contentMode = .scaleToFill
        
        cell.krTitleLabel.text = "한국어"
        cell.krTitleLabel.font = .boldSystemFont(ofSize: 20)
        
        cell.dateLabel.text = tvManager.dateFormats(date: row.releaseDate)
        cell.dateLabel.font = .systemFont(ofSize: 15)
        cell.dateLabel.textColor = .lightGray
        
        cell.moreLabel.text = "비슷한 컨텐츠 보기"
        cell.moreLabel.font = .systemFont(ofSize: 12)
        
        cell.linkButton.tag = indexPath.row
        cell.linkButton.addTarget(self, action: #selector(linkButtonClicked(_:)), for: .touchUpInside)
        
        let background = UIView()
        
        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        
        return cell
    }
    
    // 셀의 높이 동적으로 설정
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView.rowHeight
    }
    
    // sell clicked action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tvManager.tvShow[indexPath.row]
        
        // 1. 스토리보드 특정
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // 2. 스토리보드 내 많은 뷰 컨트롤러 중 전환하고자 하는 뷰컨트롤러 가저오기
        // 동일 스토리뷰일떄
        let vc = storyBoard.instantiateViewController(withIdentifier: PushViewController.identifier) as! PushViewController // 강제해제 연산자를 통해 매칭

        //Pass Data2. 표현
        vc.TvShow = row
        
        // Push: 스토리보드에서 네비게이션 컨트롤러가 임베드 되어 있는 지 확인!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func linkButtonClicked(_ sender: UIButton) { // present
        // 1. 스토리보드 특정
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // 2. 스토리보드 내 많은 뷰 컨트롤러 중 전환하고자 하는 뷰컨트롤러 가저오기
        let vc = storyBoard.instantiateViewController(withIdentifier: WebViewController.identifier) as! WebViewController
        // 강제해제 연산자를 통해 매칭
        
        vc.titleShow = tvManager.tvShow[sender.tag].title
        
        // 2-1. 네비게이션 컨트롤러 임베드
        // let nav = UINavigationController(rootViewController: vc)
        
        // 옵션
        // vc.modalTransitionStyle = .partialCurl
        // nav.modalPresentationStyle = .fullScreen
        
        // 3. present
        // present(nav, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

