//
//  Router.swift
//  Twitter API
//
//  Created by Karthik Kumar on 08/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        
        self.task?.resume()
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/x-www-form-urlencoded; charset=utf-8",
                                 forHTTPHeaderField: "Content-Type")
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case let .requestParameters(bodyParameters, urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case let .requestParametersAndHeaders(bodyParameters, urlParameters, additionHeaders):
                request.setValue("application/x-www-form-urlencoded; charset=utf-8",
                                    forHTTPHeaderField: "Content-Type")
                self.addAdditionalHeaders(additionalHeaders: additionHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                                 urlParameters: urlParameters,
                                                 request: &request)
                
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(bodyParameters: Parameters?,
                             urlParameters: Parameters?,
                             request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeaders(additionalHeaders: HTTPHeaders?,
                                      request: inout URLRequest) {
        
        guard let headers = additionalHeaders else { return }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}
