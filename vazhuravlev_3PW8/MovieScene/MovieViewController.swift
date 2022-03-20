//
//  MovieViewController.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation
import UIKit

protocol MovieDisplayLogic: AnyObject {
    func displayInfo(title: String, genres: String, popularity: String)
}

class MovieViewController: UIViewController {
    public var interactor: MovieBusinessLogic!
    private var titleLabel: UILabel?
    private var genresLabel: UILabel?
    private var popularityLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie"
        view.backgroundColor = .white
        layoutUI()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.interactor.fetchInfo()
        }
    }
    
    private func layoutUI() {
        let propsStack = UIStackView()
        propsStack.axis = .vertical
        propsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(propsStack)
        
        let (titleLabel, titleWrapper) = createPropsView(title: "Title")
        let (genresLabel, genresWrapper) = createPropsView(title: "Genres")
        let (popularityLabel, popularityWrapper) = createPropsView(title: "Popularity")
        
        propsStack.addArrangedSubview(titleWrapper)
        propsStack.addArrangedSubview(genresWrapper)
        propsStack.addArrangedSubview(popularityWrapper)
        
        NSLayoutConstraint.activate([
            propsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            propsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            propsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            titleWrapper.leadingAnchor.constraint(equalTo: propsStack.leadingAnchor),
            titleWrapper.trailingAnchor.constraint(equalTo: propsStack.trailingAnchor),
            genresWrapper.leadingAnchor.constraint(equalTo: propsStack.leadingAnchor),
            genresWrapper.trailingAnchor.constraint(equalTo: propsStack.trailingAnchor),
            popularityWrapper.leadingAnchor.constraint(equalTo: propsStack.leadingAnchor),
            popularityWrapper.trailingAnchor.constraint(equalTo: propsStack.trailingAnchor)
        ])
        
        self.titleLabel = titleLabel
        self.genresLabel = genresLabel
        self.popularityLabel = popularityLabel
    }
    
    private func createPropsView(title: String) -> (UILabel, UIView) {
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        titleLabel.text = title
        valueLabel.text = "-"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        valueLabel.font = .systemFont(ofSize: 24)
        valueLabel.numberOfLines = 2
        valueLabel.textAlignment = .right
        
        let wrapper = UIView()
        wrapper.addSubview(titleLabel)
        wrapper.addSubview(valueLabel)
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: wrapper.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: wrapper.topAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -16),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8)
        ])
        
        return (valueLabel, wrapper)
    }
}

extension MovieViewController: MovieDisplayLogic {
    func displayInfo(title: String, genres: String, popularity: String) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel?.text = title
            self?.genresLabel?.text = genres
            self?.popularityLabel?.text = popularity
        }
    }
}
