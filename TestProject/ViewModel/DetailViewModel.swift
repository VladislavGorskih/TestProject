//
//  DetailViewModel.swift
//  TestProject
//
//  Created by Владислав Даниленко on 15.01.2023.
//

import UIKit

protocol DetailViewModelProtocol {
    func fetchMovieDetailItems(movieId: Int)
    func fechMovieSimilarItems(movieId: Int)
    func changeLoading()
    
    var movieSimilarList: [MovieNowPlayingInfo]  { get set}
    var movieWebService: MovieService { get }
    var movieDetailOutPut: DetailOutPutProtocol? { get }
    
    func setDetailDelegate(output: DetailOutPutProtocol)
}

class DetailViewModel: DetailViewModelProtocol {
    
    private var isLoading = false
    
    var movieSimilarList: [MovieNowPlayingInfo] = []
    var movieWebService: MovieService
    var movieDetailOutPut: DetailOutPutProtocol?
    
    init() {
        movieWebService = MovieService()
    }
    
    func setDetailDelegate(output: DetailOutPutProtocol) {
        self.movieDetailOutPut = output
    }
    
    func fetchMovieDetailItems(movieId: Int) {
        changeLoading()
        movieWebService.fetchDetailsMovie(id: movieId) { [weak self] response, error in
            self?.changeLoading()
            guard error == nil else { return }
            self?.movieDetailOutPut?.saveMovieDetailDatas(listValues: response!)
        }
    }
    
    func fechMovieSimilarItems(movieId: Int) {
        changeLoading()
        movieWebService.fetchSimilarMovies(id: movieId) { [weak self] response, error in
            self?.changeLoading()
            guard error == nil else { return }
                self?.movieDetailOutPut?.saveSimilarMovieDatas(listValues: response!)
        }
    }
    
    func changeLoading() {
        isLoading = !isLoading
        movieDetailOutPut?.changeLoading(isLoad: isLoading)
    }
}
