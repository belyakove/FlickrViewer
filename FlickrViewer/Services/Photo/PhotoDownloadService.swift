//
//  PhotoDownloadService.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 05/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

/* Extension of PhotoModel for generating of unique
 idenifier for cahcing purpose. */

extension PhotoModel {
    var cacheIdentifier: String {
        return "\(self.id)_\(self.farm)_\(self.server)"
    }
}

typealias PhotoLoadCompletionHandler = (UIImage?, Error?) -> Void

/* Service responsible for actual images downloading and
 caching. Actual caching is implemented in the different service. */

class PhotoDownloadService {
    
    let api: APIService
    let cacheService: CacheService
    
    /*Operations need serial queue for internal synchronization but
     it would be overhead to create a separate queue for each operation so
     creating a single queue for entire service. This approach introduces
     sychronization between different operations even though it's not
     needed but it's ok since it is used for only very lightweight work
     like state changes synchronization.*/
    let syncQueue = DispatchQueue.init(label: "com.com.flickrviewer.downloadService")
    
    let downloadOperationQueue: OperationQueue
    
    init(api: APIService, cache: CacheService) {
        self.api = api
        self.cacheService = cache
        
        self.downloadOperationQueue = OperationQueue()
        self.downloadOperationQueue.maxConcurrentOperationCount = 5 //Limit number of simultaneous requests to 5
    }
    
    func loadPhoto(_ photo: PhotoModel, completion: @escaping PhotoLoadCompletionHandler) -> Cancellable {
        let operation = PhotoLoadOperation(api: self.api,
                                           cache: self.cacheService,
                                           photo: photo,
                                           syncQueue: self.syncQueue)
        operation.completionBlock = { [weak operation] in
            
            //Capturing operation with strong reference for the duration
            //of block execution so operation reference do not become
            //nil in the middle of execution.
            //Operation queue won't release operation until it's completion
            //block is finished, but just to be safe.
            guard let operation = operation else {
                completion(nil, nil)
                return
            }
            
            completion(operation.result, operation.error)
        }
        
        self.downloadOperationQueue.addOperation(operation)
        
        return operation
    }
    
}
