//
//  MovieDataStore.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import Foundation


class MovieDataStore: MovieStoreProtocol {
    //MARK: -  Model Url Info
    
    private let apiKey = "062ba0115ad103fd163deaea2e1cc026"
    private let baseUrl = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    
    //MARK: - Data Format
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    //MARK: -   Fetch Movies
    
    func fetchMovies(success: @escaping (MoviesResponse) -> Void, failure: @escaping (ErrorResponse) -> Void) {
        
        guard var urlComponents = URLComponents(string: "\(baseUrl)/movie/top_rated") else {
            return failure(.invalidEndpoint)
        }
        
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return failure(.invalidEndpoint)
        }
        
        urlSession.dataTask(with: url) { [unowned self] (data, response, error) in
            
            if error != nil {
                return failure(.apiError)
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return failure(.invalidResponse)
            }
            
            guard let data = data else {
                return failure(.noData)
            }
            
            do {
                let movieResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                DispatchQueue.main.async {
                    success(movieResponse)
                }
            } catch {
                return failure(.serializationError)
            }
        }.resume()
    }
}
