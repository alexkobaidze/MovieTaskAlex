//
//  ListMoviePresenter.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import Foundation
//MARK: - List Movi Presenter To Configure movie List
protocol ListMoviePresentationLogic {
    
    func displayMovies(movies: [Movie])
    func displayDetailMovies(with movie: Movie)
    func displayErrorMessage(error: ErrorResponse)
}

class ListMoviePresenter: ListMoviePresentationLogic {
    
    func displayDetailMovies(with movie: Movie) {
        viewController?.displayMovies(movie: [movie])
    }

    weak var viewController: ListMovieDisplayLogic?
    
    func displayMovies(movies: [Movie]) {
        viewController?.displayMovies(movie: movies)
    }
    
    func displayErrorMessage(error: ErrorResponse) {
        viewController?.displayErrorMessage(error: error)
    }
}
