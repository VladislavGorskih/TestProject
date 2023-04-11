//
//  HomeTopCell.swift
//  TestProject
//
//  Created by Владислав Даниленко on 12.01.2023.
//

import UIKit
import AlamofireImage

protocol HomeTopCellProtocol: AnyObject {
    func didPressCell(sendID: Int)
}

final class HomeTopCell: UICollectionViewCell {
    
    weak var topCellDelegate: HomeTopCellProtocol?
    
    var cellMovieUpComingList = [MovieUpComingInfo]()
    
    static var identifier = "HomeTopCell"
    
    private let topGeneralCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let colectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colectionView.showsHorizontalScrollIndicator = false
        colectionView.translatesAutoresizingMaskIntoConstraints = false
        colectionView.isPagingEnabled = true
        colectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return colectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 5
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        [topGeneralCollectionView, pageControl].forEach { contentView.addSubview($0)}
        setTopGeneralCollectionViewConstraints()
        setPageControlConstraints()
        topGeneralCollectionView.delegate = self
        topGeneralCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("not imp")
    }
}

extension HomeTopCell {
    
    func setX(model: [MovieUpComingInfo]) {
        self.cellMovieUpComingList = model
        pageControl.numberOfPages = cellMovieUpComingList.count
        topGeneralCollectionView.reloadData()
    }
}

extension HomeTopCell {
    
    private func setTopGeneralCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            topGeneralCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: -70),
            topGeneralCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topGeneralCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topGeneralCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        ])
    }
    
    private func setPageControlConstraints(){
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

extension HomeTopCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellMovieUpComingList.isEmpty == true ? 0 : cellMovieUpComingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = topGeneralCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.saveModel(model: cellMovieUpComingList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let newID = cellMovieUpComingList[indexPath.item].id else {return}
        self.topCellDelegate?.didPressCell(sendID: newID)
    }
}

extension HomeTopCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: topGeneralCollectionView.frame.width, height: topGeneralCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
