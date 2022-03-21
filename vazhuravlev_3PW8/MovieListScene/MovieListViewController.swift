//
//  MovieListViewController.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import UIKit

protocol MovieListDisplayLogic: AnyObject {
    func displayMovies(movies: [PresentedMovie], totalPages: Int)       // Displays one page of movies.
    func displayPoster(movieId: Int, poster: UIImage)                   // Displays poster for one movie.
}

class MovieListViewController: UIViewController {
    public var interactor: (MovieListBusinessLogic & SortingTypeDataStore)!
    public var router: MovieListRoutingLogic!
    private var currentSortingType = "popularity.desc"
    private var lastPageDownloaded = 1
    private var totalPages = 0
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
        self.title = "Movies"
        view.backgroundColor = .white
        configureUI()
        activityIndicator.startAnimating()
        tableView.isHidden = true
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.interactor.fetchMovies(page: 1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentSortingType != interactor.sortingType {
            currentSortingType = interactor.sortingType
            lastPageDownloaded = 1
            totalPages = 0
            movies = []
            activityIndicator.startAnimating()
            tableView.isHidden = true
            let query = self.searchField.text
            DispatchQueue.global(qos: .background).async { [weak self] in
                if let query = query, !query.isEmpty {
                    self?.interactor.searchMovies(query: query, page: 1)
                } else {
                    self?.interactor.fetchMovies(page: 1)
                }
            }
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
        tableView.tableFooterView = configureLoadingCell()
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
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(openSortChoice))
    }
    
    private func configureLoadingCell() -> UIView {
        let cell = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let indicator = UIActivityIndicatorView()
        cell.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])
        indicator.startAnimating()
        return cell
    }
    
    // Making search by query
    @objc private func makeSearch() {
        lastPageDownloaded = 1
        totalPages = 0
        movies = []
        activityIndicator.startAnimating()
        tableView.isHidden = true
        let query = self.searchField.text
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let query = query, !query.isEmpty {
                self?.interactor.searchMovies(query: query, page: 1)
            } else {
                self?.interactor.fetchMovies(page: 1)
            }
        }
    }
    
    @objc private func openSortChoice() {
        router.routeToSortChoice()
    }

}


// MARK: - UITableViewDelegate & DataSource implementation
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.routeToMovie(movieId: movies[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier) as? MovieCell
        if lastPageDownloaded == totalPages {
            tableView.tableFooterView = UIView()
        } else if indexPath.row == movies.count - 1 {
            let query = self.searchField.text
            lastPageDownloaded = lastPageDownloaded + 1
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let page = self?.lastPageDownloaded else { return }
                if let query = query, !query.isEmpty {
                    self?.interactor.searchMovies(query: query, page: page)
                } else {
                    self?.interactor.fetchMovies(page: page)
                }
            }
        }
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
    func displayMovies(movies: [PresentedMovie], totalPages: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.totalPages = totalPages
            self?.activityIndicator.stopAnimating()
            if totalPages != 0 {
                self?.tableView.isHidden = false
            }
            self?.movies.append(contentsOf: movies)
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

