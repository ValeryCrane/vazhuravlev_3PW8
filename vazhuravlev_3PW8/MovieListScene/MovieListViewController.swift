//
//  MovieListViewController.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import UIKit

protocol MovieListDisplayLogic: AnyObject {
    func displayMovies(movies: [PresentedMovie])
}

class MovieListViewController: UIViewController {
    public var interactor: MovieListBusinessLogic!
    private let tableView = UITableView()
    private var movies: [PresentedMovie] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        interactor.fetchMovies()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension MovieListViewController: UITableViewDelegate { }

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier) as? MovieCell
        cell?.configure(movie: movies[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

extension MovieListViewController: MovieListDisplayLogic {
    func displayMovies(movies: [PresentedMovie]) {
        self.movies = movies
    }
}

