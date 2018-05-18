//
//  JSONParameterEncoder.swift
//  Twitter API
//
//  Created by Karthik Kumar on 08/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8",
                                 forHTTPHeaderField: "Content-Type")
                //urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
