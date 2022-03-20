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
    private let tableView = UITableView()
    private let searchField = UITextField()
    private let activityIndicator = UIActivityIndicatorView()
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
        activityIndicator.startAnimating()
        tableView.isHidden = true
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.interactor.fetchMovies()
        }
    }
    
    
    // MARK: - setup functions
    private func configureUI() {
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "Search"
        searchField.font = .systemFont(ofSize: 24)
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(makeSearch), for: .editingChanged)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            separator.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 32),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 2),
            
            tableView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // Making search by query
    @objc private func makeSearch() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        let query = self.searchField.text
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let query = query, !query.isEmpty {
                self?.interactor.searchMovies(query: query)
            } else {
                self?.interactor.fetchMovies()
            }
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

// MARK: - UITextFieldDelegate implementation
extension MovieListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - MovieListDisplayLogic implementation
extension MovieListViewController: MovieListDisplayLogic {
    func displayMovies(movies: [PresentedMovie]) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            if movies.count != 0 {
                self?.tableView.isHidden = false
            }
            self?.movies = movies
            for movie in movies {
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self?.interactor.fetchPoster(movieId: movie.id, posterPath: movie.posterPath)
                }
            }
        }
    }
    
    func displayPoster(movieId: Int, poster: UIImage) {
        DispatchQueue.main.async { [weak self] in
            for i in 0..<(self?.movies.count ?? 0) {
                if self?.movies[i].id == movieId {
                    self?.movies[i].poster = poster
                }
            }
        }
    }
}

