//
//  MovieListPresenter.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation

protocol MovieListPresentationLogic {
    func presentMovies(data: [String: Any])
}

class MovieListPresenter {
    public weak var view: MovieListDisplayLogic!
}

extension MovieListPresenter: MovieListPresentationLogic {
    func presentMovies(data: [String: Any]) {
        guard let results = data["results"] as? [[String: Any]] else { return }
        let movies: [PresentedMovie] = results.compactMap { params in
            let title = params["title"] as? String
            let posterPath = params["poster_path"] as? String
            if let title = title, let posterPath = posterPath {
                return PresentedMovie(title: title, posterPath: posterPath, poster: nil)
            } else {
                return nil
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.view.displayMovies(movies: movies)
        }
    }
}
