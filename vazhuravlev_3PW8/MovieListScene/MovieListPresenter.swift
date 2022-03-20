//
//  MovieListPresenter.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation
import UIKit

protocol MovieListPresentationLogic {
    func presentMovies(data: [String: Any])             // Converts movies to [PresentedMovie].
    func presentPoster(movieId: Int, imageData: Data)    // Presents image to view.
}

class MovieListPresenter {
    public weak var view: MovieListDisplayLogic!
}

// MARK: - MovieListPresentationLogic implementation
extension MovieListPresenter: MovieListPresentationLogic {
    func presentMovies(data: [String: Any]) {
        guard let results = data["results"] as? [[String: Any]] else { return }
        let movies: [PresentedMovie] = results.compactMap { params in
            let title = params["title"] as? String
            let posterPath = params["poster_path"] as? String
            let movieId = params["id"] as? Int
            if let title = title, let posterPath = posterPath, let movieId = movieId {
                return PresentedMovie(id: movieId, title: title, posterPath: posterPath, poster: nil)
            } else {
                return nil
            }
        }
        view.displayMovies(movies: movies)
    }
    
    func presentPoster(movieId: Int, imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        self.view.displayPoster(movieId: movieId, poster: image)
    }
}
