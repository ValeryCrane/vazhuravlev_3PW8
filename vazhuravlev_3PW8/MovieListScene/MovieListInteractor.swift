//
//  MovieListInteractor.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation

protocol MovieListBusinessLogic {
    func fetchMovies(page: Int)                             // Fetches one page of movies.
    func searchMovies(query: String, page: Int)             // Fethces one page of certain movies.
    func fetchPoster(movieId: Int, posterPath: String)      // Fetches a poster.
}

protocol SortingTypeDataStore: AnyObject {
    var sortingType: String { get set }                     // How to sort a movie.
}

class MovieListInteractor:SortingTypeDataStore {
    public var presenter: MovieListPresentationLogic!
    private static let apiKey = "d61da1ef04f1834074b116b6d36f799e"
    private var urlSession: URLSession?
    public var sortingType: String = "popularity.desc"
    
    // Cancels all tasks in URLSession.shared
    private func cancelAllSharedTasks() {
        URLSession.shared.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
}

// MARK: - MovieListBusinessLogic implementation
extension MovieListInteractor: MovieListBusinessLogic {
    func fetchMovies(page: Int) {
        guard let url = URL(
                string: "https://api.themoviedb.org/3/discover/movie?api_key=\(Self.apiKey)&language=ruRu&sort_by=\(sortingType)&page=\(page)")
        else { return }
        
        if page == 1 {
            cancelAllSharedTasks()
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, _ in
            if let data = data,
               let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                self?.presenter.presentMovies(data: dictionary)
            }
            
        }
        task.resume()
    }
    
    func searchMovies(query: String, page: Int) {
        guard let url = URL(string:
            "https://api.themoviedb.org/3/search/movie?api_key=\(Self.apiKey)&language=ruRu&query=\(query.replacingOccurrences(of: " ", with: "%20"))&sort_by=\(sortingType)&page=\(page)")
        else { return }
        
        if page == 1 {
            cancelAllSharedTasks()
        }
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
            self?.presenter?.presentPoster(movieId: movieId, imageData: data)
        }
        task.resume()
    }
}
