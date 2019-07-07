//
//  NetworkingService.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

typealias NetworkRequestCompletionHandler = (Data?, Error?) -> Void

enum HTTPMethod {
    case get
    case post
}

/* Protocol defining generic networking service */

protocol NetworkingService {
    func executeRequest(withURL url: URL, method: HTTPMethod, completionHandler: @escaping NetworkRequestCompletionHandler) -> Cancellable
}
