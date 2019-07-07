//
//  APIServiceImpl.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 07/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

class APIServiceImpl: APIService {
    let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    func executeObjectRequest<T: APIObjectRequest>(_ request: T, completionHandler: @escaping APIObjectRequestCompletionHandler<T.Result>) -> Cancellable {
        
        return self.networkingService.executeRequest(withURL: request.url, method: request.method, completionHandler: { (data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                completionHandler(nil, URLError(.badServerResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.Result.self, from: data)
                completionHandler(result, nil)
            }
            catch {
                completionHandler(nil, error)
            }
        })
    }
    
    func executeRequest(_ request: APIRequest, completionHandler: @escaping APIRequestCompletionHandler) -> Cancellable {
        return self.networkingService.executeRequest(withURL: request.url, method: request.method) { (data, error) in
            completionHandler(data, error)
        }
    }

}
