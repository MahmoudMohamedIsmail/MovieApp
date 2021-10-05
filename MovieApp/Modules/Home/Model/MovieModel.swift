//
//  MovieModel.swift
//  MovieApp
//
//  Created by Mahmoud Ismail on 10/5/21.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity, voteAverage: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteCount: Int?
    
    var posterURL: URL?{
        guard let path = posterPath else{
            return nil
        }
        return URL(string: "\(Constants.baseImageURL)\(path)")
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
