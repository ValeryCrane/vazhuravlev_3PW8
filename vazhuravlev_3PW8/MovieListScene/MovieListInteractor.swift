//
//  MovieListInteractor.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation

protocol MovieListBusinessLogic {
    func fetchMovies()
}

class MovieListInteractor {
    private static let apiKey = "d61da1ef04f1834074b116b6d36f799e"
}

extension MovieListInteractor: MovieListBusinessLogic {
    func fetchMovies() {
        guard let url = URL(
                string: "https://api.themoviedb.org/3/discover/movie?api_key=\(Self.apiKey)&language=ruRu")
        else { return }
        
        let session = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            print(data as Any)
        }
        session.resume()
    }
}
