//
//  iTunesAPI.swift
//  iTunesAPI
//
//  Created by 大江祥太郎 on 2021/09/06.
//

import Foundation
import Reachability

class iTunesAPI {
    
    private static var task: URLSessionTask?
    
    enum SearchRepositoryError: Error {
        case wrong
        case network
        case parse
    }
    
    static func searchRepository(text: String, completionHandler: @escaping (Result<[Song], SearchRepositoryError>) -> Void) {
        if !text.isEmpty {
            
            let reachability = try! Reachability()
            if reachability.connection == .unavailable {
                completionHandler(.failure(SearchRepositoryError.network))
                return
            }
            let urlString = "https://itunes.apple.com/search?term=\(text)&entity=song&country=jp".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            //let urlString = "https://api.github.com/search/repositories?q=\(text)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(SearchRepositoryError.wrong))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
                if err != nil {
                    completionHandler(.failure(SearchRepositoryError.network))
                    return
                }
                
                guard let date = data else {return}
                
                if let result = try? jsonStrategyDecoder.decode(Songs.self, from: date) {
                    completionHandler(.success(result.results))
                } else {
                    completionHandler(.failure(SearchRepositoryError.parse))
                }
            }
            task.resume()
        }
    }
    
    static private var jsonStrategyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    static func taskCancel() {
        task?.cancel()
    }
}
