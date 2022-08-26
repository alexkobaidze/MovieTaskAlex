//
//  MovieService.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import Foundation

//Mark: -  Fetch Movie Data

protocol MovieStoreProtocol {
    func fetchMovies(success: @escaping (_ movie: MoviesResponse)-> Void, failure: @escaping (_ error: ErrorResponse)-> Void)
}

class MovieService {
    
    var movieStore: MovieStoreProtocol
    
    init(movieStore: MovieStoreProtocol) {
        self.movieStore = movieStore
    }
    
    func fetchMovies(onSuccess: @escaping (_ movies: [Movie]) -> Void, onFailure: @escaping (_ error: ErrorResponse) -> Void) {
        movieStore.fetchMovies { (response) in
            DispatchQueue.main.async {
                onSuccess(response.results)
            }
        } failure: { (error: ErrorResponse) in
            DispatchQueue.main.async {
                onFailure(error)
            }
        }
    }
}


public enum ErrorResponse: String {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    public var description: String {
        switch self {
        case .apiError: return "apiError"
        case .invalidEndpoint: return "invalidEndpoint"
        case .invalidResponse: return "invalidResponse"
        case .noData: return "noData"
        case .serializationError: return " serialization process eror"
        }
    }
}
