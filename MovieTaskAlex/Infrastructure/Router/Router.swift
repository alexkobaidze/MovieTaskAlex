//
//  Router.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import Foundation
import UIKit

protocol MovieRouterDependencies {
    func createListMovieViewController() -> ListMovieViewController
}

final class MovieRouter {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MovieRouterDependencies
    
    init(navigationController: UINavigationController, dependencies: MovieRouterDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func startApp() {
        let tabBarViewController = dependencies.createListMovieViewController()
        navigationController?.pushViewController(tabBarViewController, animated: true)
    }
}
