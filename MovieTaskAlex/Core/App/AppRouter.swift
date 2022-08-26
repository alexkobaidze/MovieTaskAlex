//
//  AppRouter.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import Foundation

import UIKit

final class AppRouter {
    
    private let appDIContainer: AppDIContainer
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func startRoute() {
        let movieScenesDIContainer = appDIContainer.createMovieSceneDIContainer()
        let router = movieScenesDIContainer.createMovieRouter(navigationController: navigationController)
        router.startApp()
    }
}
