//
//  MoviePresenter.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation
import UIKit

protocol MoviePresentationLogic {
    func presentMovie(data: [String: Any])      // Presents movie info.
    func presentPoster(imageData: Data)         // Presents movie poster.
}

class MoviePresenter {
    public weak var view: MovieDisplayLogic!
}

// MARK: - MoviePresentationLogic implementation.
extension MoviePresenter: MoviePresentationLogic {
    func presentMovie(data: [String : Any]) {
        guard let title = data["title"] as? String,
              let genresInfo = data["genres"] as? [[String: Any]],
              let genres = genresInfo.map({ $0["name"] }) as? [String],
              let popularity = data["popularity"] as? Double,
              let posterPath = data["poster_path"] as? String
        else { return }
            
        let genresText = genres.joined(separator: ", ")
        let popularityText = "\(popularity)"
            
        view.displayInfo(title: title, genres: genresText, popularity: popularityText, posterPath: posterPath)
    }
    
    func presentPoster(imageData: Data) {
        self.view.displayPoster(poster: UIImage(data: imageData) ?? UIImage())
    }
}
