//
//  HTTPTask.swift
//  Twitter API
//
//  Created by Karthik Kumar on 08/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String:String]

typealias Parameters = [String:Any]

enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}
