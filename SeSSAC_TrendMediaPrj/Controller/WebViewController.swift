//
//  WebViewController.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/19.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    static let identifier = "WebViewController"
    
    @IBOutlet weak var presentWebView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var titleShow: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< BACK", style: .plain, target: self, action: #selector(closeButtonClicked(_:)))
        
        searchBar.delegate = self
    }
    
    @objc func closeButtonClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func xButtonPressed(_ sender: Any) {
        presentWebView.stopLoading()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if presentWebView.canGoBack {
            presentWebView.goBack()
        } else {
            print("Back Error")
        }
        
    }
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        presentWebView.reload()
    }
    
    @IBAction func forwardButtonPressed(_ sender: Any) {
        if presentWebView.canGoForward {
            presentWebView.goForward()
        } else {
            print("Forward Error")
        }
    }
}

extension WebViewController: UISearchBarDelegate {
    // 검색 리턴키 클릭
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let url = URL(string: searchBar.text ?? "") else {
            print("ERROR")
            return
        }
        
        let request = URLRequest(url: url)
        presentWebView.load(request)
    }
}
