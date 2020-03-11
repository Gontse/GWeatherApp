//
//  ServiceHelper.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/08.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String {
    case GET    = "get"
    case POST   = "post"
    case DELETE = "delete"
    case PATCH  = "patch"
}

struct Resource<T:Codable> {
    let url: URL
    var httpVerb: HttpMethod = .GET
    var body: Data? = nil
}

class ServiceHelper {
    func load<T>(resource: Resource<T>, completion: @escaping(Result<T, NetworkError>) -> Void ){
        
        var request = URLRequest(url: resource.url)        
        request.httpMethod = resource.httpVerb.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else{
                completion(.failure(.decodingError))
                return
            }
            let results = try? JSONDecoder().decode(T.self, from: data)
            if let result = results {
                completion(.success(result))
            }else{
                completion(.failure(.domainError))
            }
        }.resume()
    }
}
