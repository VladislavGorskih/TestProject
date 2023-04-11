//
//  BottomCell.swift
//  TestProject
//
//  Created by Владислав Даниленко on 12.01.2023.
//

import UIKit

final class BottomCell: UICollectionViewCell {
    
    static var identifier = "BottomCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let definitionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLable)
        contentView.addSubview(definitionLabel)
        contentView.addSubview(releaseDateLabel)
      
        
        setImageViewConstraints()
        setTitleLabelConstraints()
        setDefinitionleLabelConstraints()
        setreleaseDateLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not imp")
    }
    
    func saveModel(model: MovieNowPlayingInfo) {
        let defaultLink = "http://image.tmdb.org/t/p/w500"
        let completePath = defaultLink + model.posterPath
        titleLable.text = "\(model.title)"
        imageView.af.setImage(withURL: URL(string: completePath)!)
        definitionLabel.text = "\(model.overview)"
        releaseDateLabel.text = "\(model.releaseDate)"
    }
}

extension BottomCell {
    private func setImageViewConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.height)
        ])
    }
    
    private func setTitleLabelConstraints(){
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLable.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            titleLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35),
        ])
    }
    
    private func setDefinitionleLabelConstraints(){
        NSLayoutConstraint.activate([
            definitionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            definitionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            definitionLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 8)
        ])
    }
    
    private func setreleaseDateLabelConstraints(){
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: definitionLabel.bottomAnchor, constant: 5),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            releaseDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}

