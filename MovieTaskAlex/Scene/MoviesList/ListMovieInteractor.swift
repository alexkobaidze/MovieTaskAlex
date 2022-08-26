//
//  ListMovieInteractor.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import Foundation

protocol ListMovieDataLogic {
    func fetchMovies()
    var showAlert: ((String, String)->())? { get set }
    func startNetworkMonitoring()
    func didSelectRow(at indexPath: IndexPath)
}

protocol ListMovieDataStore {
    var movies: [Movie] { get }
}

class ListMovieInteractor: ListMovieDataLogic, ListMovieDataStore {
   
    //MARK: - Variables
    
    private let presenter: ListMoviePresentationLogic
    private let movieService: MovieService
    private let reachability = try? Reachability()
    var movies: [Movie] = []
    var showAlert: ((String, String)->())?
    
    
    init(presenter: ListMoviePresentationLogic, movieService: MovieService) {
        self.presenter = presenter
        self.movieService = movieService
    }
    //MARK: - ListMovie Manupulation
    
    func getMovie(at indexPath: IndexPath) -> Movie {
        return movies[indexPath.row]
    }
    func numberOfRows() -> Int {
        return movies.count
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let movie = getMovie(at: indexPath)
        presenter.displayDetailMovies(with: movie)
    }
    
    func fetchMovies() {
        movieService.fetchMovies { [weak self] (movies: [Movie]) in
            guard let self = self else {
                return
            }
            
            self.movies = movies
            self.presenter.displayMovies(movies: movies)
        } onFailure: { [weak self] (error: ErrorResponse) in
            guard let self = self else {
                return
            }
            
            self.presenter.displayErrorMessage(error: error)
        }
    }
    
    func startNetworkMonitoring() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.reachability?.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            self.reachability?.whenUnreachable = { _ in
                print("Not reachable")
                self.showAlert?("Oops...", "Something went wrong with your connection, Please try to connect internet again.")
            }

            do {
                try self.reachability?.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
    
    func stopNetworkMonitoring() {
        reachability?.stopNotifier()
    }
}

