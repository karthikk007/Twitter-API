//
//  NetworkError.swift
//  Twitter API
//
//  Created by Karthik Kumar on 08/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameter encoding failed"
    case missingURL = "URL is nil"
}
