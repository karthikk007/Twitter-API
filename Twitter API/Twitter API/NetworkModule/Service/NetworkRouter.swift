//
//  NetworkRouter.swift
//  Twitter API
//
//  Created by Karthik Kumar on 08/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

typealias NetworkRouterCompletion = (_ data: Data?, _ reponse: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}


