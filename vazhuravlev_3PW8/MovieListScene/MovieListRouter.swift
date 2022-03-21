//
//  MovieListRouter.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 21.03.2022.
//

import Foundation
import UIKit

protocol MovieListRoutingLogic {
    func routeToMovie(movieId: Int)         // Routes to movie page.
    func routeToSortChoice()                // Routes to choice of sort.
}

class MovieListRouter {
    public weak var view: UIViewController!
    public weak var sortingTypeDataStore: SortingTypeDataStore!
}

// MARK: - MovieListRoutingLogic implementation
extension MovieListRouter: MovieListRoutingLogic {
    func routeToMovie(movieId: Int) {
        let movie = MovieAssembly().assemble(movieId: movieId)
        view.navigationController?.pushViewController(movie, animated: true)
    }
    
    func routeToSortChoice() {
        let sortChoiceView = SortChoiceViewController()
        sortChoiceView.sortingTypeDataStore = sortingTypeDataStore
        view.navigationController?.pushViewController(sortChoiceView, animated: true)
    }
}
