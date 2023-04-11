//
//  SearchCompositionalResultsVC.swift
//  TestProject
//
//  Created by Владислав Даниленко on 13.01.2023.
//

import UIKit

protocol SearchMovieOutPutProtocol {
    func saveSearchingResult(movieValues: [MovieUpComingInfo])
}

final class SearchCompositionalResultsVC: UIViewController {
    public var result: [MovieUpComingInfo] = []
    
    public var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: SearchCompositionalResultsVC.createCompositionalLayout())
        collectionView.register(SearchCustomCell.self,
                                forCellWithReuseIdentifier: SearchCustomCell.identifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let mylayout = UICollectionViewCompositionalLayout { (index, enviroment) -> NSCollectionLayoutSection? in
            return SearchCompositionalResultsVC.createSectionFor(index: index, envr: enviroment)
        }
        return mylayout
    }
    
    static func createSectionFor(index: Int, envr: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        return createThirdSection()
    }
    
    static func createThirdSection() -> NSCollectionLayoutSection {
        let inset: CGFloat = 2.5
        
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [smallItem])
        
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [largeItem, verticalGroup, verticalGroup])
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    public func configure(model: [MovieUpComingInfo]) {
        self.result = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        [searchResultsCollectionView].forEach { view.addSubview($0)}
        searchResultsCollectionView.collectionViewLayout = SearchCompositionalResultsVC.createCompositionalLayout()
        setConstraints()
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
    }
}


extension SearchCompositionalResultsVC {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchResultsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 95),
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchCompositionalResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchResultsCollectionView.dequeueReusableCell(withReuseIdentifier: SearchCustomCell.identifier, for: indexPath) as! SearchCustomCell
        let mymodel = result[indexPath.row]
        cell.configure(with: mymodel.posterPath ?? "")
        cell.layer.borderWidth = 0.7
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 8
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        cell.layer.shadowRadius = 3
        cell.layer.shadowOffset = .zero
        cell.layer.shadowOpacity = 0.6
        return cell
    }
}
