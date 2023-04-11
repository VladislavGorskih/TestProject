//
//  CompositonalCustomCell.swift
//  TestProject
//
//  Created by Владислав Даниленко on 12.01.2023.
//

import UIKit

final class SearchCustomCell: UICollectionViewCell {

    static var identifier = "SearchCustomCell"

    public var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("not imp")
    }

    public func configure(with model: String) {
        guard var url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else {return}
        if model.isEmpty {
            url = URL(string: "https://digitalfinger.id/wp-content/uploads/2019/12/no-image-available-icon-6.png")!
        }
        myImageView.af.setImage(withURL: url)
    }
}

extension SearchCustomCell {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: topAnchor),
            myImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            myImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
