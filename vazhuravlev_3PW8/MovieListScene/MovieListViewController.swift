//
//  MovieListViewController.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import UIKit

protocol MovieListDisplayLogic: AnyObject {
    func displayMovies(movies: [PresentedMovie])            // Displays one page of movies.
    func displayPoster(movieId: Int, poster: UIImage)       // Displays poster for one movie.
}

class MovieListViewController: UIViewController {
    public var interactor: MovieListBusinessLogic!
    private var dispatchGroup: DispatchGroup?
    private let tableView = UITableView()
    private var posters: [UIImage?] = []
    private var movies: [PresentedMovie] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - ViewController's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.interactor.fetchMovies()
        }
    }
    
    
    // MARK: - setup functions
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
    
    private func showAllPosters() {
        for i in 0..<movies.count {
            movies[i].poster = posters[i]
        }
    }

}


// MARK: - UITableViewDelegate & DataSource implementation
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


// MARK: - MovieListDisplayLogic implementation
extension MovieListViewController: MovieListDisplayLogic {
    func displayMovies(movies: [PresentedMovie]) {
        DispatchQueue.main.async { [weak self] in
            self?.movies = movies
            self?.dispatchGroup = DispatchGroup()
            self?.posters = [UIImage?](repeating: UIImage(), count: movies.count)
            for movie in movies {
                self?.dispatchGroup?.enter()
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self?.interactor.fetchPoster(movieId: movie.id, posterPath: movie.posterPath)
                }
            }
            self?.dispatchGroup?.notify(queue: .main) { [weak self] in
                self?.showAllPosters()
            }
        }
    }
    
    func displayPoster(movieId: Int, poster: UIImage) {
        DispatchQueue.main.async { [weak self] in
            for i in 0..<(self?.movies.count ?? 0) {
                if self?.movies[i].id == movieId {
                    self?.posters[i] = poster
                    self?.dispatchGroup?.leave()
                }
            }
        }
    }
}

