//
//  PhotoRequest.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

struct PhotoRequest: APIRequest {

    typealias Result = Data
    let photoModel: PhotoModel
    
    init(photoModel: PhotoModel) {
        self.photoModel = photoModel
    }
    
    var url: URL {
        let urlString = "http://farm\(photoModel.farm).static.flickr.com/\(photoModel.server)/\(photoModel.id)_\(photoModel.secret).jpg"
        return URL(string: urlString)! //Not very safe way but in this case we know the string exactly
    }
    
}
