//
//  Alert+Extention.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/21.
//

import UIKit

extension UIViewController {
    
    func test() {
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let megabox = UIAlertAction(title: "메가박스", style: .default) { _ in
            
        }
        
        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { _ in
            
        }
        
        let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
            
        }
        
        let filterFree = UIAlertAction(title: "전체보기", style: .default) { _ in
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [megabox, lotte, cgv, filterFree, cancel].forEach { action in
            actionAlert.addAction(action)
        }
        
        present(actionAlert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, okTitle: String, okAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            print("확인 버튼 눌렀음")
            
            
            okAction()
        
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true) {
            print("얼럿이 떴습니다.")
        }
    }
}
