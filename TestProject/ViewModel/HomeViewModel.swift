//
//  HomeViewModel.swift
//  TestProject
//
//  Created by Владислав Даниленко on 15.01.2023.
//

import UIKit

protocol HomeViewModelProtocol {
    func fetchNowPlayingItems()
    func changeLoading()
    func fetchUpComingItems()
    
    var movieNowPlayingList: [MovieNowPlayingInfo] { get set }
    var movieWebService: MovieService { get }
    var movieOutPut: MovieOutPutProtocol? { get }
    
    func setDelegate(output: MovieOutPutProtocol)
}

class HomeViewModel: HomeViewModelProtocol {
    
    private var isLoading = false
    
    var movieNowPlayingList: [MovieNowPlayingInfo] = []
    var movieUpComingList: [MovieUpComingInfo] = []
    var movieWebService: MovieService
    var movieOutPut: MovieOutPutProtocol?
    
    init() {
        movieWebService = MovieService()
    }
    
    func setDelegate(output: MovieOutPutProtocol) {
        movieOutPut = output
    }
    
    func fetchNowPlayingItems() {
        changeLoading()
        movieWebService.fetchNowPlayingMovies(movieType: .nowPlaying) {[ weak self ] response, error in
            self?.changeLoading()
            guard error == nil else { return }
            self?.movieNowPlayingList = response ?? []
            self?.movieOutPut?.saveMovieNowPlayingDatas(listValues: self?.movieNowPlayingList ?? [])
        }
    }
    
    func fetchUpComingItems() {
        changeLoading()
        movieWebService.fetchUpComingMovies(movieType: .upComing) { [weak self] response, error in
            self?.changeLoading()
            guard error == nil else { return }
            self?.movieUpComingList = response ??  []
            self?.movieOutPut?.saveMovieUpComingPlayingDatas(listValues: self?.movieUpComingList ?? [])
        }
    }
    
    func changeLoading() {
        isLoading.toggle()
        movieOutPut?.changeLoading(isLoad: isLoading)
    }
}
