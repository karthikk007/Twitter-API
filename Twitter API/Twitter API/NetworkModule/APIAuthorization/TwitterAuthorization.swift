//
//  TwitterAuthorization.swift
//  Twitter API
//
//  Created by Karthik Kumar on 09/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

protocol TwitterAuthorization {
    var oAuthSigningKey: String { get }
    var oAuthToken: String { get }
    var nonce: String { get }
    var timestamp: String { get }
    var authVersion: String { get }
}

extension TwitterAuthorization {
    
    // Generate Sorted Parameter String for base string params
    func generateSortedParameterString(params: Parameters,
                                       oAuthHeaders: HTTPHeaders) -> String {
        
        var parameters = [String: String]()
        
        for (key, value) in oAuthHeaders {
            parameters[key] = value
        }
        
        for (key, value) in params {
            parameters[key] = String(describing: value)
        }
        
        let keys = parameters.keys.sorted()
        
        
        var paramString: String = ""
        
        for i in 0..<keys.count {
            if i == 0 {
                paramString = keys[i] + "=" + parameters[keys[i]]!
            } else {
                paramString = paramString + "&" + keys[i] + "=" + parameters[keys[i]]!.percentEncodedString()
            }
        }
        
        return paramString
    }
    
    // generate base string
    func getAuthBaseString(method: String,
                           url: String,
                           params: Parameters,
                           oAuthHeaders: HTTPHeaders) -> String {
        
        let sortedString = generateSortedParameterString(params: params,
                                                         oAuthHeaders: oAuthHeaders)
        
        return method
            + "&" + url.percentEncodedString()
            + "&" + sortedString.percentEncodedString()
        
    }
    
    // generate signature
    func getAuthSignature(for text: String, key: String) -> String {
        let signature = text.hmac(key: key)
        return signature.percentEncodedString()
    }
    
    func getAuthorizationString(method: String,
                                url: String,
                                apiKey: String,
                                oAuthHeaders: HTTPHeaders,
                                params: Parameters) -> String {
        
        let baseString = getAuthBaseString(method: method, url: url, params: params, oAuthHeaders: oAuthHeaders)
        
//        let signature = getAuthSignature(for: baseString, key: oAuthSigningKey)
        let signature = Data((getAuthSignature(for: baseString, key: oAuthSigningKey)).utf8).base64EncodedString()
        
        print(baseString)
        
        
        let kar = "=&$?"
        
//        kar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print("kar = \(kar.percentEncodedString()))")
        
        return "OAuth "
        + "oauth_consumer_key=\"" + apiKey.percentEncodedString() + "\", "
        + "oauth_nonce=\"" + nonce.percentEncodedString() + "\", "
        + "oauth_signature=\"" + signature.percentEncodedString() + "\", "
        + "oauth_signature_method=\"" + "HMAC-SHA1" + "\", "
        + "oauth_timestamp=\"" + timestamp + "\", "
        + "oauth_token=\"" + oAuthToken.percentEncodedString() + "\", "
        + "oauth_version=\"" + authVersion.percentEncodedString() + "\""

    }
}
