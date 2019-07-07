//
//  APIObjectRequest.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

/* Protocol defining request that is decoded
 from JSON into an object */
 
protocol APIObjectRequest: APIRequest {
    associatedtype Result: Decodable
}
