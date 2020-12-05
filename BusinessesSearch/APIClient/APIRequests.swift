//
//  APIRequests.swift
//  BusinessesSearch
//
//  Created by Sharaf Nazaar on 12/4/20.
//

import Foundation

class APIRequests {
    
func getBusinesses(searchTerm: String,
                    latitude: Double,
                    longitude: Double,
                    limit: Int,
                    sortBy: String,
                    radius: Int,
                    completionHandler: @escaping ([Business]?, Error?) -> Void) {
    
    let searchTermEncoded = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    
    let serv = APIClient()
    let queryItems = [
        URLQueryItem(name: "term", value: searchTermEncoded),
        URLQueryItem(name: "latitude", value: String(latitude)),
        URLQueryItem(name: "longitude", value:  String(longitude)),
        URLQueryItem(name: "limit", value:  String(limit)),
        URLQueryItem(name: "sortBy", value:  String(sortBy)),
        URLQueryItem(name: "radius", value:  String(radius))
    ]
    
    serv.get(path: customEndPoint, queryItems: queryItems)
    { (response) in
        switch response {
        case .success(let data):
            guard let jsonData = data else {
                return
            }
        do {
            let decoder = JSONDecoder()
            let businessData = try decoder.decode(BusinessesModel.self, from: jsonData)
            completionHandler(businessData.businesses, nil)
        } catch {
            completionHandler(nil, nil)
//            print("Caught error", data?.description)
        }
          
        case .failure(let error):
            completionHandler(nil, nil)
//            print(error.localizedDescription)
        }
    }
}
}
