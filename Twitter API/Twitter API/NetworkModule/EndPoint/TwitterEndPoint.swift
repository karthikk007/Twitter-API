//
//  TwitterEndPoint.swift
//  Twitter API
//
//  Created by Karthik Kumar on 08/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

enum TwitterAPI {
    case trending
}

extension TwitterAPI: TwitterAuthorization {
    
    var oAuthSigningKey: String {
        return TwitterAuthorizationInfo.apiSecret.rawValue + "&" + TwitterAuthorizationInfo.accessTokenSecret.rawValue
    }
    
    var oAuthToken: String {
        return "\(TwitterAuthorizationInfo.ownerId.rawValue)-\(TwitterAuthorizationInfo.accessToken.rawValue)"
    }
    
    var timestamp: String {
        return String(Int(TwitterAPIDownloadManager.timeStamp))
    }
    
    var nonce: String {
        return Data((TwitterAuthorizationInfo.apiKey.rawValue + ":" + String(timestamp)).utf8).base64EncodedString()
    }
    
    var authVersion: String {
        return TwitterAuthorizationInfo.version.rawValue
    }
}

extension TwitterAPI: EndPointType {
    

    
    var woeid: String {
        return "1"
    }
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.twitter.com") else {
            fatalError("base url could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .trending:
            return "\(authVersion)/trends/place.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .trending:
            return .get
        }
    }
    

    

    
    var urlParameters: Parameters {
        let parameters: Parameters = ["id": "\(woeid)"]
        return parameters
    }
    
    var parameterString: String {
        
        let parameter = "id=\(woeid)".percentEncodedString()
        
//        let parameterString: String = parameter
        
        return parameter
    }
    
    var task: HTTPTask {
        switch self {
        case .trending:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                urlParameters: urlParameters,
                                                additionHeaders: headers)
        }
    }
    
    var oAuthHeaders: HTTPHeaders {
        let parameters: HTTPHeaders = ["oauth_consumer_key": TwitterAuthorizationInfo.apiKey.rawValue,
                                       "oauth_signature_method": "HMAC-SHA1",
                                       "oauth_token": oAuthToken,
                                       "oauth_nonce": nonce,
                                       "oauth_timestamp": timestamp,
                                       "oauth_version": TwitterAuthorizationInfo.version.rawValue]
        return parameters
    }
    
    var headers: HTTPHeaders? {
        
        let parameters: HTTPHeaders = ["Authorization": getAuthorizationString(method: httpMethod.rawValue,
                                                                               url: baseURL.appendingPathComponent(path).absoluteString,
                                                                               apiKey: TwitterAuthorizationInfo.apiKey.rawValue,
                                                                               oAuthHeaders: oAuthHeaders,
                                                                               params: urlParameters)]
        
        return parameters
    }
}


