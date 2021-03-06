//
//  MovieCell.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 20.03.2022.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    static let reuseIdentifier = "MovieCell"
    private let poster = UIImageView()
    private let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
        configureUI()
    }
    
    // Layouts and configures UI elements.
    private func configureUI() {
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.contentMode = .scaleToFill
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(poster)
        addSubview(title)
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: topAnchor),
            poster.leadingAnchor.constraint(equalTo: leadingAnchor),
            poster.trailingAnchor.constraint(equalTo: trailingAnchor),
            poster.heightAnchor.constraint(equalToConstant: 200),
            
            title.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        title.textAlignment = .center
    }
    
    // Configures cell based on given data.
    func configure(movie: PresentedMovie) {
        title.text = movie.title
        poster.image = movie.poster
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
