//
//  MockAPIService.swift
//  FlickrViewerTests
//
//  Created by Eugene Belyakov on 07/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit
@testable import FlickrViewer

class CancellableMock: Cancellable {
    func cancel() {}
}

class MockAPIService: APIService {
    
    var error: Error?
    var result: Any?
    var data: Data?
    
    func executeObjectRequest<T: APIObjectRequest>(_ request: T, completionHandler: @escaping APIObjectRequestCompletionHandler<T.Result>) -> Cancellable {
        
        completionHandler(self.result as? T.Result, self.error)
        
        return CancellableMock()
    }
    
    func executeRequest(_ request: APIRequest, completionHandler: @escaping APIRequestCompletionHandler) -> Cancellable {
        completionHandler(self.data, self.error)
        return CancellableMock()
    }
}
