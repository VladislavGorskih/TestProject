//
//  DetailBottomCell.swift
//  TestProject
//
//  Created by Владислав Даниленко on 12.01.2023.
//

import UIKit

final class DetailBottomCell: UICollectionViewCell {
    
    static var identifier =  "DetailBottomCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.numberOfLines = 3
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
        setConstraints()
    }
    
    func setUp(model: MovieNowPlayingInfo) {
        let defaultLink = "http://image.tmdb.org/t/p/w500"
        let completePath = defaultLink + model.posterPath
        imageView.af.setImage(withURL: URL(string: completePath)!)
        titleLable.text = "\(model.title) (\(model.releaseDate.prefix(4)))"
    }
    
    required init?(coder: NSCoder) {
        fatalError("not imp")
    }
}

extension DetailBottomCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.height/1.5),
            
            titleLable.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80)
        ])
    }
}
