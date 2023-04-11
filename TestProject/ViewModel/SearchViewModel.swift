//
//  SearchViewModel.swift
//  TestProject
//
//  Created by Владислав Даниленко on 15.01.2023.
//

import UIKit

protocol SearchViewModelProtocol {
    func setSearchDelegate(output: SearchMovieOutPutProtocol)
    var searchOutPut: SearchMovieOutPutProtocol? { get }
}


class SearchViewModel: SearchViewModelProtocol {
    
    var searchOutPut: SearchMovieOutPutProtocol?
    var movieWebService: MovieService
    var resultCont: SearchCompositionalResultsVC?
    
    
    init() {
        movieWebService = MovieService()
    }
    
    
    func setSearchDelegate(output: SearchMovieOutPutProtocol) {
        searchOutPut = output
    }
}
