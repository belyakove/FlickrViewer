//
//  APIRequest.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

/* Protocol defining generic network request */

protocol APIRequest {
    var method: HTTPMethod { get }
    var url: URL { get }
}

extension APIRequest {
    var method: HTTPMethod {
        return .get
    }
}
