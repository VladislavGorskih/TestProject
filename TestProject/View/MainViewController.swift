//
//  ViewController.swift
//  TestProject
//
//  Created by Владислав Даниленко on 12.01.2023.
//

import UIKit

protocol MovieOutPutProtocol {
    func changeLoading(isLoad: Bool)
    func saveMovieNowPlayingDatas(listValues: [MovieNowPlayingInfo])
    func saveMovieUpComingPlayingDatas(listValues: [MovieUpComingInfo])
}

final class MainViewController: UIViewController {

    lazy var homeMovieNowPlayingList: [MovieNowPlayingInfo] = []
    lazy var homeMovieUpComingList: [MovieUpComingInfo] = []
    lazy var viewModel = HomeViewModel()
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    var searchMode = false
    var filteredList = [MovieNowPlayingInfo]()
    
    private let generalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .black
        
        cv.register(HomeTopCell.self, forCellWithReuseIdentifier: HomeTopCell.identifier)
        cv.register(BottomCell.self, forCellWithReuseIdentifier: BottomCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let searcController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchCompositionalResultsVC())
        controller.searchBar.placeholder = "Поиск"
        controller.searchBar.tintColor = .white
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        viewModel.setDelegate(output: self)
        viewModel.fetchNowPlayingItems()
        viewModel.fetchUpComingItems()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searcController
        searcController.searchResultsUpdater = self
        
        addPullToRefreshToWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setupView() {
        view.addSubview(generalCollectionView)
        view.addSubview(indicator)
        MainViewConstraints()
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow, NSAttributedString.Key.font:
                                                    UIFont(name: "Chalkduster", size: 32.0)!]
        navBarAppearance.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Kinopoisk"
        generalCollectionView.delegate = self
        generalCollectionView.dataSource = self
        indicator.startAnimating()
    }
    
    func addPullToRefreshToWebView() {
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshWebView), for: .valueChanged)
        generalCollectionView.refreshControl = refreshControl
    }
    
    @objc func refreshWebView() {
        viewModel.fetchNowPlayingItems()
        viewModel.fetchUpComingItems()
        refreshControl.endRefreshing()
    }
}

extension MainViewController: MovieOutPutProtocol {
    
    func changeLoading(isLoad: Bool) {
        isLoad ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    func saveMovieNowPlayingDatas(listValues: [MovieNowPlayingInfo]) {
        homeMovieNowPlayingList = listValues
        generalCollectionView.reloadData()
    }
    
    func saveMovieUpComingPlayingDatas(listValues: [MovieUpComingInfo]) {
        homeMovieUpComingList = listValues
        generalCollectionView.reloadData()
    }
}

extension MainViewController {
    private func MainViewConstraints() {
        NSLayoutConstraint.activate([
            generalCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            generalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            generalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            generalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return searchMode ? filteredList.count : self.homeMovieNowPlayingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let topCell = generalCollectionView.dequeueReusableCell(withReuseIdentifier: HomeTopCell.identifier, for: indexPath) as! HomeTopCell
            topCell.setX(model: homeMovieUpComingList)
            topCell.topCellDelegate = self
            return topCell
        }
        let bottomCell = generalCollectionView.dequeueReusableCell(withReuseIdentifier: BottomCell.identifier, for: indexPath) as! BottomCell
        bottomCell.backgroundColor = .black
        bottomCell.layer.shadowColor = UIColor.white.cgColor
        bottomCell.layer.shadowPath = UIBezierPath(rect: bottomCell.bounds).cgPath
        bottomCell.layer.shadowRadius = 3
        bottomCell.layer.shadowOffset = .zero
        bottomCell.layer.shadowOpacity = 0.6
        
        searchMode ? bottomCell.saveModel(model: filteredList[indexPath.item]) : bottomCell.saveModel(model: homeMovieNowPlayingList[indexPath.item])
        return bottomCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            return 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.myId = homeMovieNowPlayingList[indexPath.item].id
        navigationController?.pushViewController(movieDetailVC, animated: false)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: generalCollectionView.frame.width, height: 350)
        }
        return CGSize(width: generalCollectionView.frame.width, height: generalCollectionView.frame.width - 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        }
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
}

extension MainViewController: HomeTopCellProtocol {
    
    func didPressCell(sendID: Int) {
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.myId = sendID
        self.navigationController?.pushViewController(movieDetailVC, animated: false)
    }
}

extension MainViewController: UISearchResultsUpdating {
     
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
                  !query.trimmingCharacters(in: .whitespaces).isEmpty,
                  query.trimmingCharacters(in: .whitespaces).count >= 3,
              var resultController = searchController.searchResultsController as? SearchCompositionalResultsVC else {return}
        
        MovieService.shared.getSearch(with: query) { (res,error) in
            DispatchQueue.main.async {
                resultController.configure(model: res ?? [])
                resultController.searchResultsCollectionView.reloadData()
            }
        }
    }
}
