//
//  NetworkService.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 22.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation

typealias RequestClosure = (_ data: Data?, _ error: Error?) -> Void

class NetworkServiceWithUrlSession: NetworkServiceProtocol {
    static let shared = NetworkServiceWithUrlSession()
    
    // MARK: Requests
    
    func get(path: String, parameters: [String: Any]?, completion: @escaping RequestClosure) {
        request("GET", path: path, parameters: parameters, completion: completion)
    }

    func post(path: String, parameters: [String: Any]?, completion: @escaping RequestClosure) {
        request("POST", path: path, parameters: parameters, completion: completion)
    }

    fileprivate func request(_ method: String, path: String, parameters: [String: Any]?, completion: @escaping RequestClosure)  {
        print("Request '\(path)', '\(method)' [.]")
        let params = (parameters == nil ? "[]" : (parameters!.isEmpty ? "[]" : parameters!.description))
        print("Parameters: \(params)")
        var urlRequest: URLRequest!

        if method == "GET"{
            let urlComp = NSURLComponents(string: path)!
            var items = [URLQueryItem]()
            for (key,value) in parameters! {
                items.append(URLQueryItem(name: key, value: String(describing: value)))
            }
            items = items.filter{!$0.name.isEmpty}
            if !items.isEmpty {
                urlComp.queryItems = items
            }
            urlRequest = URLRequest(url: urlComp.url!)
            urlRequest.httpMethod = method
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            completion(data, error)
        }.resume()
    }
}
