//
//  TMDBAPIManager.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/28.
//

import Foundation
import SwiftyJSON
import Alamofire

class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    typealias CompletionHandler = (Int, JSON) -> ()
    
    func getMovieDataDemo(page: Int, mediaOpt: String, term: String, result: @escaping CompletionHandler) {
        
        let url = "\(Endpoint.tmdbURL)trending/\(mediaOpt)/\(term)?api_key=\(APIKey.TMDB_KEY)" + "&query=&page=\(page)"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200...500)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("trend api success")
                let json = JSON(value)
                let code = response.response?.statusCode ?? 500
                result(code, json)
            case .failure(let error): // 네트워크 통신 실패시
                print(error)
            }
        }
    }
    
    func getCreditDataDemo(movieId: Int, mediaOpt: String, result: @escaping CompletionHandler) {
        
        let url = "\(Endpoint.tmdbURL)/\(mediaOpt)/\(movieId)/credits?api_key=\(APIKey.TMDB_KEY)&language=en-US"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200...500)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("credit api success")
                let json = JSON(value)
                let code = response.response?.statusCode ?? 500
                result(code, json)
            case .failure(let error): // 네트워크 통신 실패시
                print(error)
            }
        }
    }
    
    func getMovieVideoDataURLDemo(movieId: Int, result: @escaping CompletionHandler) {
        
        let url = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(APIKey.TMDB_KEY)&language=en-US"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200...500)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("video api success")
                let json = JSON(value)
                let code = response.response?.statusCode ?? 500
                result(code, json)
            case .failure(let error): // 네트워크 통신 실패시
                print(error)
            }
        }
    }
}
