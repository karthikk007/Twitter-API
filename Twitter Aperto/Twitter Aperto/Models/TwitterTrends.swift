//
//  TwitterTrends.swift
//  Twitter Aperto
//
//  Created by Karthik Kumar on 11/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

struct TwitterTrends: Decodable {
    let name: String
    let url: String
    let promotedContent: String?
    let query: String
    let tweetVolume: Int?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case promotedContent = "promoted_content"
        case query
        case tweetVolume = "tweet_volume"
    }
}
