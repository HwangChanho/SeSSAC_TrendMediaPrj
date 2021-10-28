//
//  TMDBMovie.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/28.
//

import Foundation

struct TMDBMovie {
    let posterPath: String
    let video: Bool
    let type: String
    let backdropPath: String
    let overview: String
    let title: String
    let releaseDate: String
    let language: String
    let movieId: Int
}

struct Credit {
    let character: String
    let gender: Int
    let name: String
    let profilePath: String
}
