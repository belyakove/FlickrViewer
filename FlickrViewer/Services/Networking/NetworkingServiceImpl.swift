//
//  NetworkingService.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

extension HTTPMethod {
    var urlRequestValue: String {
        switch self {
        case .get:
            return "GET"
        default:
            return "POST"
        }
    }
}

extension URLSessionDataTask: Cancellable {}

class NetworkingServiceImpl: NetworkingService {
    
    let session = URLSession(configuration: .default)
    
    
    func executeRequest(withURL url: URL, method: HTTPMethod = .get, completionHandler: @escaping NetworkRequestCompletionHandler) -> Cancellable {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.urlRequestValue
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                completionHandler(data, error)
                return
            }
            
            completionHandler(data, nil)
        }
        
        task.resume()
        return task
    }
}
