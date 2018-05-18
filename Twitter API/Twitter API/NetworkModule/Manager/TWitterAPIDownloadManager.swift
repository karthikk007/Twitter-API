//
//  TWitterAPIDownloadManager.swift
//  Twitter API
//
//  Created by Karthik Kumar on 08/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "Error in Authentication"
    case badRequest = "Bad Request"
    case outdated = "outdated request"
    case failed = "Network request failed"
    case noData = "no response"
    case decodeFailed = "could not decode"
}

enum Result<String> {
    case success
    case failure(String)
}

struct TwitterAPIDownloadManager {

    private let router = Router<TwitterAPI>()
    
    static var timeStamp: TimeInterval = Date().timeIntervalSince1970
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599:
            return .failure(NetworkResponse.badRequest.rawValue)
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func getTrends(completion: @escaping (_ trends: TwitterAPIResponse?, _ error: String?) -> ()) {
        
        router.request(.trending) { (data, response, error) in
            
            if error != nil {
                completion(nil, "check your internet connection")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode(TwitterAPIResponse.self, from: data)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkResponse.decodeFailed.rawValue)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
                
            }
         }
    }
    
}
