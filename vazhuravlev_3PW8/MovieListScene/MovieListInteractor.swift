//
//  MovieListInteractor.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation

protocol MovieListBusinessLogic {
    func fetchMovies()                                      // Fetches one page of movies.
    func fetchPoster(movieId: Int, posterPath: String)      // Fetches a poster.
}

class MovieListInteractor {
    public var presenter: MovieListPresentationLogic!
    private static let apiKey = "d61da1ef04f1834074b116b6d36f799e"
}

// MARK: - MovieListBusinessLogic implementation
extension MovieListInteractor: MovieListBusinessLogic {
    func fetchMovies() {
        guard let url = URL(
                string: "https://api.themoviedb.org/3/discover/movie?api_key=\(Self.apiKey)&language=ruRu")
        else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, _ in
            if let data = data,
               let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                self?.presenter.presentMovies(data: dictionary)
            }
            
        }
        task.resume()
    }
    
    func fetchPoster(movieId: Int, posterPath: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/original/\(posterPath)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, _ in
            guard let data = data else { return }
            self?.presenter?.presentImage(movieId: movieId, imageData: data)
        }
        task.resume()
    }
}
