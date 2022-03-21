//
//  MovieAssembly.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 21.03.2022.
//

import Foundation
import UIKit

// Assembles view with movie description.
class MovieAssembly {
    func assemble(movieId: Int) -> UIViewController {
        let view = MovieViewController()
        let interactor = MovieInteractor()
        let presenter = MoviePresenter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        
        interactor.movieId = movieId
        
        return view
    }
}
