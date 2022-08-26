//
//  MovieScenesDIContainer.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import Foundation

import UIKit

final class MovieScenesDIContainer {
    
    //TODO: Define Dependecies Here
    
    
    //MARK:- Router
    
    func createMovieRouter(navigationController: UINavigationController) -> MovieRouter {
        return MovieRouter(navigationController: navigationController, dependencies: self)
    }
    
}

extension MovieScenesDIContainer: MovieRouterDependencies {
    
    //MARK:- Scenes
    
    func createListMovieViewController() -> ListMovieViewController {
        let presenter = ListMoviePresenter()
        
        let interactor = ListMovieInteractor(
            presenter: presenter,
            movieService: MovieService(
                movieStore: MovieDataStore()
            )
        )
        
        let viewController = ListMovieViewController(
            interactor: interactor
        )
        
        presenter.viewController = viewController
        return viewController
    }
    
}
