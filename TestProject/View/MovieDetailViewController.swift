//
//  MovieDetailViewController.swift
//  TestProject
//
//  Created by Владислав Даниленко on 12.01.2023.
//

import UIKit

protocol DetailOutPutProtocol {
    func changeLoading(isLoad: Bool)
    func saveMovieDetailDatas(listValues: MovieDetailsModel)
    func saveSimilarMovieDatas(listValues: [MovieNowPlayingInfo])
}

final class MovieDetailViewController: UIViewController {
    
    var detailsMovie: MovieDetailsModel?
    
    private lazy var detailMovieSimilarList: [MovieNowPlayingInfo] = []
    var viewModel = DetailViewModel()
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var myId = 5
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imbIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imdbIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let starIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star.fill")
        imageView.tintColor = .yellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let definitionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(DetailBottomCell.self, forCellWithReuseIdentifier: DetailBottomCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let underPictureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let smilarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "More videos"
        label.textColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.setDetailDelegate(output: self)
        viewModel.fetchMovieDetailItems(movieId: myId)
        viewModel.fechMovieSimilarItems(movieId: myId)
    }
    
    func setupView() {
        let subView = [imageView, imbIcon, starIcon, ratingLabel, releaseLabel, titleLable, definitionLabel, underPictureStackView, bottomCollectionView, smilarLabel]
        let arrangedStackView = [imbIcon, starIcon, ratingLabel, releaseLabel]
        
        subView.forEach { (item) in
            view.addSubview(item)
        }
        arrangedStackView.forEach { (item) in
            underPictureStackView.addArrangedSubview(item)
        }
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.backgroundColor = .clear
        setConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "house"), style: .done, target: self, action: #selector(goHomeBtn))
    }
    
    @objc func goHomeBtn() {
        navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    func setConstraints() {
        setimageViewConstraints()
        setStackViewConstraints()
        setStarIconConstraints()
        setTitleConstraints()
        setDefinitionConstraints()
        setbottomCollectionView()
    }
}

extension MovieDetailViewController: DetailOutPutProtocol {
    
    func changeLoading(isLoad: Bool) {
        isLoad ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    func saveMovieDetailDatas(listValues: MovieDetailsModel) {
        DispatchQueue.main.async {
            self.detailsMovie = listValues
            let movieInfo = self.detailsMovie
            let defaultLink = "http://image.tmdb.org/t/p/w500"
            var moviePref: String
            if let mypath = self.detailsMovie?.posterPath {
                moviePref = mypath
            } else {
                moviePref = "1"
            }
            let completePath = defaultLink + moviePref
            self.imageView.af.setImage(withURL: URL(string: completePath)!)
            self.titleLable.text = "\(movieInfo?.title ?? "-") ( \(movieInfo?.releaseDate?.prefix(4) ?? "-") )"
            self.definitionLabel.text = "\(movieInfo?.overview ?? "-")"
            self.ratingLabel.text = "\(movieInfo?.voteAverage ?? 0.0) / 10"
            self.releaseLabel.text = "\(movieInfo?.releaseDate?.prefix(2) ?? "-")"
        }
    }
    
    func saveSimilarMovieDatas(listValues: [MovieNowPlayingInfo]) {
        self.detailMovieSimilarList = listValues
        bottomCollectionView.reloadData()
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailMovieSimilarList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bottomCell = bottomCollectionView.dequeueReusableCell(withReuseIdentifier: DetailBottomCell.identifier, for: indexPath) as! DetailBottomCell
        bottomCell.setUp(model: detailMovieSimilarList[indexPath.item])
        return bottomCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.myId = detailMovieSimilarList[indexPath.row].id
        navigationController?.pushViewController(movieDetailVC, animated: false)
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (bottomCollectionView.frame.width) - 20,
                      height: bottomCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MovieDetailViewController {
     
    func setimageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 320)
        ])
    }
    
    func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            underPictureStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            underPictureStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            underPictureStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            underPictureStackView.heightAnchor.constraint(equalToConstant: 37)
        ])
    }
    
    func setImbdbIconConstraints(){
        NSLayoutConstraint.activate([
            imbIcon.topAnchor.constraint(equalTo: underPictureStackView.topAnchor),
            imbIcon.leadingAnchor.constraint(equalTo: underPictureStackView.leadingAnchor),
            imbIcon.trailingAnchor.constraint(equalTo: starIcon.leadingAnchor, constant: -20),
            imbIcon.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setStarIconConstraints(){
        NSLayoutConstraint.activate([
            starIcon.topAnchor.constraint(equalTo: underPictureStackView.topAnchor),
            starIcon.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            starIcon.bottomAnchor.constraint(equalTo: underPictureStackView.bottomAnchor, constant: -25),
            starIcon.heightAnchor.constraint(equalToConstant: 5),
        ])
    }
    
    func setTitleConstraints(){
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: underPictureStackView.bottomAnchor, constant: 10),
            titleLable.leadingAnchor.constraint(equalTo: underPictureStackView.leadingAnchor),
            titleLable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setDefinitionConstraints(){
        NSLayoutConstraint.activate([
            definitionLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            definitionLabel.leadingAnchor.constraint(equalTo: underPictureStackView.leadingAnchor),
            definitionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            definitionLabel.bottomAnchor.constraint(equalTo: smilarLabel.topAnchor, constant: -10)
        ])
    }
    
    private func setbottomCollectionView(){
        NSLayoutConstraint.activate([
            smilarLabel.topAnchor.constraint(equalTo: definitionLabel.bottomAnchor, constant: 10),
            smilarLabel.leadingAnchor.constraint(equalTo: definitionLabel.leadingAnchor),
            smilarLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            smilarLabel.bottomAnchor.constraint(equalTo: bottomCollectionView.topAnchor,constant: -15),
            
            bottomCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 5),
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
































