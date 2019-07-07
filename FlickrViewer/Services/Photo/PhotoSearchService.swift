//
//  PhotoSearchService.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

typealias PhotoSearchCompletionHandler = (BucketModel?, Error?) -> Void

/* Service responsible for performing search of photos
 and retrieveing list of photo models. */

class PhotoSearchService: NSObject {
    
    let api: APIService
    
    init(api: APIService) {
        self.api = api
    }
    
    func loadBucketForSearchTerm(_ searchTerm: String, page: Int = 0, completion: @escaping PhotoSearchCompletionHandler) -> Cancellable {
        
        let request = SearchRequest(searchTerm, page: page)
        
        return self.api.executeObjectRequest(request) { (result, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let bucket = result?.bucket {
                completion(bucket, nil)
                return
            }
            
            completion(nil, URLError(.badServerResponse))
        }
    }
}
