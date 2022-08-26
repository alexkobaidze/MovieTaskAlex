//
//  AppDIContainer.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import UIKit

final class AppDIContainer {
    
    //TODO: Define Dependecies Here
    
    
    //MARK:- Scenes DI Container
    func createMovieSceneDIContainer() -> MovieScenesDIContainer {
        return MovieScenesDIContainer()
    }
}
