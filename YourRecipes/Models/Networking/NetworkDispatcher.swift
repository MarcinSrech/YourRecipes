//
//  NetworkDispatcher.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import Foundation
import Hydra

enum NetworkErrors: Error {
    case badInput
    case noData
}

class NetworkDispatcher: Dispatcher {
    
    private var environment: Environment
    private var session: URLSession
    
    required init(environment: Environment) {
        self.environment = environment
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func execute(request: Request) throws -> Promise<Response> {
        let rq = try self.prepareURLRequest(for: request)
        return Promise<Response>(in: .background, { resolve, _, _ in
            let d = self.session.dataTask(with: rq, completionHandler: { (data, urlResponse, error) in
                let response = Response( (urlResponse as? HTTPURLResponse, data, error), for: request)
                resolve(response)
            })
            d.resume()
        })
    }
    
    private func prepareURLRequest(for request: Request) throws -> URLRequest {
        let fullURL = "\(environment.host)/\(request.path)"
        var urlRequest = URLRequest(url: URL(string: fullURL)!)
        
        switch request.parameters {
        case .body(let params):
            if let params = params as? [String: String] {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
            } else {
                throw NetworkErrors.badInput
            }
        case .url(let params):
            if let params = params as? [String: String] {
                let queryParams  = params.map({ URLQueryItem(name: $0.key, value: $0.value) })
                guard var components = URLComponents(string: fullURL) else {
                    throw NetworkErrors.badInput
                }
                components.queryItems = queryParams
                urlRequest.url = components.url
            } else {
                throw NetworkErrors.badInput
            }
        }
        
        
        environment.headers.forEach({ urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) })
        request.headers?.forEach({ urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) })
        
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
    
}
