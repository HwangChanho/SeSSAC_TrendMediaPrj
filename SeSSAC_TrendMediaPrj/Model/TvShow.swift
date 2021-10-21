//
//  TvShow.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/16.
//

import Foundation
import UIKit

//enum SettingSection: Int, CaseIterable {
//    case authorization
//    case onlineShop
//    case question
//    
//    var description: String {
//        switch self {
//        case .authorization:
//            return "알림 설정"
//        case .onlineShop:
//            return "온라인 스토어"
//        case .question:
//            return "Q&A"
//        }
//    }
//}

struct TvShow {
    var title: String           // 제목
    var releaseDate: String     // 개봉일
    var genre: String           // 장르
    var region: String          // 국가
    var overview: String        // 개요
    var rate: Double            // 평점
    var starring: String        // 주연
    var backdropImage: String   // 이미지
}

