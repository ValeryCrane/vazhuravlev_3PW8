//
//  MovieListAssembly.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation
import UIKit

class MovieListAssembly {
    func assemble() -> UIViewController {
        let view = MovieListViewController()
        let interactor = MovieListInteractor()
        
        view.interactor = interactor
        
        return view
    }
}
