//
//  APIService.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

typealias APIObjectRequestCompletionHandler<T> = (T?, Error?) -> Void
typealias APIRequestCompletionHandler = (Data?, Error?) -> Void

protocol APIService {
    func executeObjectRequest<T: APIObjectRequest>(_ request: T, completionHandler: @escaping APIObjectRequestCompletionHandler<T.Result>) -> Cancellable
    func executeRequest(_ request: APIRequest, completionHandler: @escaping APIRequestCompletionHandler) -> Cancellable
}
