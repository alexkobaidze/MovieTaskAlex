//
//  Movie.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

//MARK: -  Model For Movie
import Foundation

public struct MoviesResponse: Codable {
    public let page: Int?
    public let totalResults: Int?
    public let totalPages: Int?
    public let results: [Movie]
}

public struct Movie: Codable, Hashable {
    
    public let id: Int?
    public let title: String?
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String?
    public let releaseDate: Date?
    public let voteAverage: Double?
    public let voteCount: Int?
    public let tagline: String?
    public let adult: Bool?
    public let runtime: Int?
    public var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }

    
}


