//
//  WebService.swift
//  TestProject
//
//  Created by Владислав Даниленко on 15.01.2023.
//

import UIKit
import Alamofire

enum MovieTypes: String {
    case nowPlaying = "now_playing"
    case upComing = "upcoming"
}

final class MovieService {
    
    let apiBaseUrl = "https://api.themoviedb.org/3/movie/"
    let languageAndPage = "&language=en-US&page=1#"
    let myApiKey = "e79aecc9e78fe074b640b272c8b3bbd9"
    
    typealias cHandler = ([MovieNowPlayingInfo]?,String?) -> Void
    typealias cUpComingHandler = ([MovieUpComingInfo]?, String?) -> Void
    typealias detailHandler = (MovieDetailsModel?,String?) -> Void
    
    static let shared = MovieService()
    
    func fetchNowPlayingMovies(movieType: MovieTypes, completion: @escaping cHandler) {
        let endPoint = apiBaseUrl + "\(movieType.rawValue)?api_key=\(myApiKey)" + languageAndPage
        let request = AF.request(endPoint)
        request.validate().responseDecodable(of: MovieNowPlayingModel.self) { response in
            switch response.result {
            case .success(let movieInfos):
                    completion(movieInfos.results, nil)
            case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
    
    func fetchUpComingMovies(movieType: MovieTypes, completion: @escaping cUpComingHandler) {
        let endPoint = apiBaseUrl + "\(movieType.rawValue)?api_key=\(myApiKey)" + languageAndPage
        let request = AF.request(endPoint)
        request.validate().responseDecodable(of: MovieUpComingModel.self) { response in
            switch response.result {
            case .success(let movieInfos):
                    completion(movieInfos.results, nil)
            case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
    
    func fetchDetailsMovie(id: Int, completion: @escaping detailHandler) {
        let endPoint = apiBaseUrl + "\(id)?api_key=\(myApiKey)" + languageAndPage
        let request = AF.request(endPoint)
        request.validate().responseDecodable(of: MovieDetailsModel.self) { response in
            switch response.result {
            case .success(let movieDetailInfos):
                completion(movieDetailInfos, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func fetchSimilarMovies(id: Int, completion: @escaping cHandler){
        let endPoint = apiBaseUrl + "\(id)/similar?api_key=\(myApiKey)" + languageAndPage
        let request = AF.request(endPoint)
        request.validate().responseDecodable(of: MovieNowPlayingModel.self) { response in
            switch response.result {
            case .success(let movieInfos):
                completion(movieInfos.results, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    public func getSearch(with query: String, completion: @escaping  cUpComingHandler) {
       guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return}
       let urlString =  "https://api.themoviedb.org/3/search/movie?api_key=\(myApiKey)&query=\(query)"
        let request = AF.request(urlString)
        request.validate().responseDecodable(of: MovieUpComingModel.self) { response in
            switch response.result {
            case .success(let movieInfos):
                completion(movieInfos.results, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
