//
//  APIClient.swift
//  BusinessesSearch
//
//  Created by Sharaf Nazaar on 12/4/20.
//

import Foundation

class APIClient {
    
    public var scheme: String = "https"
    public var host: String = customHost
    public var apiKey : String? = customAPIKey
    public var contentType: String? = "application/json"
    
    public var session = URLSession(configuration: .default)
    
    public init() {}
    
    public enum HTTPMethod: String {
        case get = "GET"
    }
    
    public func request(method: HTTPMethod, components: URLComponents, headers: [HTTPHeader], onComplete: @escaping (Result<Data?, RequestError>) -> Void) {
        
        guard let url = components.url else {
            onComplete(.failure(.init(message: "Could not create valid URL from components.")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        for header in headers {
            request.add(header: header)
        }

        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                onComplete(.failure(.init(message: "Did not get an http response")))
                return
            }
            
            if let error = error as NSError? {
                onComplete(.failure(.init(message: "\(response.statusCode): \(error.localizedDescription)")))
                return
            }
            
            onComplete(.success(data))
        }
        task.resume()
    }
        
    public func get(path: String, queryItems: [URLQueryItem]? = nil, onComplete: @escaping (Result<Data?, RequestError>) -> Void) {
        var components = self.components(path: path)
        components.queryItems = queryItems
        request(method: .get, components: components, headers: defaultHeaders(), onComplete: onComplete)
    }
    
    func defaultHeaders() -> [HTTPHeader] {
        var headers: [HTTPHeader] = []
        if let contentType = self.contentType {
            headers.append(HTTPHeader(field: .contentType, value: contentType))
        }
        
        if let apiKey = self.apiKey {
            headers.append(HTTPHeader(field: .authorization, value: "Bearer \(apiKey)"))
        }
        return headers
    }
    
    func components(path: String) -> URLComponents {
        var components = URLComponents()
        components.host = self.host
        components.path = path
        components.scheme = scheme
        return components
    }
}
