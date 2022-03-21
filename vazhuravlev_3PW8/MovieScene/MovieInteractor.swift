//
//  MovieInteractor.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation

protocol MovieDataStore: AnyObject {
    var movieId: Int? { get set }               // Given movie id.
}

protocol MovieBusinessLogic {
    func fetchInfo()                            // Fetches info about movie.
    func fetchPoster(posterPath: String)        // Fetches movie poster.
}

class MovieInteractor: MovieDataStore {
    static let apiKey = "d61da1ef04f1834074b116b6d36f799e"
    public var presenter: MoviePresentationLogic!
    var movieId: Int?
}

// MARK: - MovieBusinessLogic implementation
extension MovieInteractor: MovieBusinessLogic {
    func fetchInfo() {
        guard
            let movieId = movieId, let url = URL(
                string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(Self.apiKey)&language=ruRu")
        else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, _ in
            if let data = data,
               let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                self?.presenter.presentMovie(data: dictionary)
            }
            
        }
        task.resume()
    }
    
    func fetchPoster(posterPath: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/original/\(posterPath)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, _ in
            guard let data = data else { return }
            self?.presenter?.presentPoster(imageData: data)
        }
        task.resume()
    }
}
