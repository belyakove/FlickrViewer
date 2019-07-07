//
//  SearchResponseModel.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

struct SearchResponseModel: Codable {
    let bucket: BucketModel
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case bucket = "photos"
        case status = "stat"
    }
}
