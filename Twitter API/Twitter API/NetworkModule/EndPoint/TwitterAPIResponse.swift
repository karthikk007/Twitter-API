//
//  TwitterAPIResponse.swift
//  Twitter API
//
//  Created by Karthik Kumar on 08/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

struct TwitterAPIResponse: Decodable {
    let trends: [TwitterTrends]
    let asOf: Date
    let createdAt: Date
    let locations: [TwitterLocation]
    
    private enum CodingKeys: String, CodingKey {
        case trends
        case asOf = "as_of"
        case createdAt = "created_at"
        case locations
    }
}


struct TwitterTrends: Decodable {
    let name: String
    let url: String
    let promotedContent: String
    let query: String
    let tweetVolume: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case promotedContent = "promoted_content"
        case query
        case tweetVolume = "tweet_volume"
    }
}

struct TwitterLocation: Decodable {
    let name: String
    let woeid: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case woeid
    }
}
