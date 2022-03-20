//
//  MovieListAssembly.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation
import UIKit

// Assembles MovieListScene
class MovieListAssembly {
    func assemble() -> UIViewController {
        let view = MovieListViewController()
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        
        return view
    }
}
