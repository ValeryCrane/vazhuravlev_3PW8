//
//  MovieListRouter.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 21.03.2022.
//

import Foundation
import UIKit

protocol MovieListRoutingLogic {
    func routeToMovie(movieId: Int)
}

class MovieListRouter {
    public weak var view: UIViewController!
}

extension MovieListRouter: MovieListRoutingLogic {
    func routeToMovie(movieId: Int) {
        let movie = MovieAssembly().assemble(movieId: movieId)
        view.navigationController?.pushViewController(movie, animated: true)
    }
}
