//
//  CollectionViewCell.swift
//  TestProject
//
//  Created by Владислав Даниленко on 12.01.2023.
//

import UIKit
import Alamofire
import AlamofireImage

final class CollectionViewCell: UICollectionViewCell {
    
    static var identifier = "CollectionViewCell"
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let definitionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        [movieImageView, transparentView, titleLable, definitionLabel, labelStackView].forEach { contentView.addSubview($0)}
        setMovieImageViewConstraints()
        setTransparentViewConstraints()
        setTitleConstraints()
        setDefinitionConstraints()
        setStackViewConstraints()
        
        [titleLable, definitionLabel].forEach { contentView.addSubview($0)}
    }
    
    required init?(coder: NSCoder) {
        fatalError("not Imp")
    }
}

extension CollectionViewCell {
    public func saveModel(model: MovieUpComingInfo) {
        let defaultLink = "http://image.tmdb.org/t/p/w500"
        let completePath = defaultLink + (model.backdropPath ?? "")
        titleLable.text = "\(model.title ?? "")"
        movieImageView.af.setImage(withURL: URL(string: completePath)!)
        titleLable.text = "\(model.title ?? "-")"
        definitionLabel.text = "\(model.overview ?? "-")"
    }
}

extension CollectionViewCell {
    
    private func  setMovieImageViewConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func setTransparentViewConstraints() {
        NSLayoutConstraint.activate([
            transparentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            transparentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            transparentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
   
    private func setTitleConstraints() {
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: labelStackView.topAnchor, constant: 80),
            titleLable.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            titleLable.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor),
            titleLable.bottomAnchor.constraint(equalTo: definitionLabel.topAnchor)
            
        ])
    }
    
    
    private func setDefinitionConstraints() {
        NSLayoutConstraint.activate([
            definitionLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor),
            definitionLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            definitionLabel.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor),
            definitionLabel.bottomAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: -50)
        ])
    }
}
