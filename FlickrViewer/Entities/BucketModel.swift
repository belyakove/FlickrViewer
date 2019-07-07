//
//  BucketModel.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

struct BucketModel: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photos: [PhotoModel]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perpage = "perpage"
        case total = "total"
        case photos = "photo"
    }
    
    /* Have to implement decoding manually because
     in JSON numbers sometimes might be represented as strings.
     More details in KeyedDecodingContainer extension*/
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decodeJSONInt(forKey: .page)
        self.pages = try container.decodeJSONInt(forKey: .pages)
        self.perpage = try container.decodeJSONInt(forKey: .perpage)
        self.total = try container.decodeJSONInt(forKey: .total)
        self.photos = try container.decode([PhotoModel].self, forKey: .photos)
    }
}
