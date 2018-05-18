//
//  TwitterAPIDownloader.swift
//  Twitter Aperto
//
//  Created by Karthik Kumar on 11/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation
import CoreLocation

enum TwitterAPIError {
    case success
    case failure
}

class TwitterAPIDownloader {
    
    private let twitter: STTwitterAPI
    
    static let shared = TwitterAPIDownloader()
    
    private init() {
        twitter = STTwitterAPI(oAuthConsumerKey: TwitterAuthorizationInfo.apiKey.rawValue,
                                   consumerSecret: TwitterAuthorizationInfo.apiSecret.rawValue,
                                   oauthToken: TwitterAuthorizationInfo.accessToken.rawValue,
                                   oauthTokenSecret: TwitterAuthorizationInfo.accessTokenSecret.rawValue)
        
    }
    
    func getWoeid(location: CLLocation, completion: @escaping (Int, TwitterAPIError) -> ()) {
        
        twitter.getTrendsClosest(toLatitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), successBlock: { (result) in
            
            if let result = result as? [[String: Any]] {
                if let data = result.first, let woeid = data["woeid"] as? Int {
                    completion(woeid, .success)
                    return
                }
            }
            
            completion(-1, .failure)
            
        }) { (error) in
            completion(-1, .failure)
        }
        
    }
    
    func fetchTrends<T: Decodable>(for woeid: Int, decode: T.Type, completion: @escaping (T?, TwitterAPIError) -> ()) {
        twitter.verifyCredentials(userSuccessBlock: { (userName, userID) in
            print("success \(userName!) - \(userID!)")
            print("woeid = \(woeid)")
            
            
            self.twitter.getTrendsForWOEID(String(woeid), excludeHashtags: 0, successBlock: { (asOf, createdAt, locations, trends) in
                
                print(trends)
                
                if let trends = trends as? [[String: Any]] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: trends, options: .prettyPrinted)
                        let arr = try JSONDecoder().decode(decode, from: data)
                        completion(arr, .success)
                    } catch {
                        completion(nil, .failure)
                        print(error)
                    }
                }
            }, errorBlock: { (error) in
                completion(nil, .failure)
                print(error!)
            })
        }, errorBlock: { (error) in
            completion(nil, .failure)
            print(error!)
        })
    }
    

}
