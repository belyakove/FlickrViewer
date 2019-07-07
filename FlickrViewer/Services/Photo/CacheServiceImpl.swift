//
//  CacheService.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 05/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

/* File cache for images*/

/* Cache service uses caches directory for storing
 image files so for this task relying on iOS behaviour
 for cleaning obsolete data. */

class CacheServiceImpl: CacheService {
    
    /* Loading from disk is an expensive operation
     so we'll need to do it asynchronously */
    
    private let syncQueue = DispatchQueue(label: "com.flickrviewer.cacheservice.sync")
    
    private func cacheFileNameForIdetifier(_ identifier: String) -> URL? {
        guard var url = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }
        url.appendPathComponent("\(identifier).jpg", isDirectory: false)
        return url
    }
    
    func loadCachedImageForIdentifier(_ identifier: String, completionHandler: @escaping LoadImageCompletionHandler) {
        
        self.syncQueue.async {
            guard let fileURL = self.cacheFileNameForIdetifier(identifier) else {
                completionHandler(nil)
                return
            }
            
            /* Creating image trough Data but not through UIImage directly bcause
             unlike Data, UIImage doesn't have method that accepts URL,
             it can accept only string */
            
            guard let data = try? Data(contentsOf: fileURL) else {
                completionHandler(nil)
                return
            }
            
            let image = UIImage(data: data)
            completionHandler(image)
        }
    }
    
    func cache(image: UIImage, forIdentifier identifier: String) {
        
        self.syncQueue.async {
            guard let fileURL = self.cacheFileNameForIdetifier(identifier) else {
                return
            }
            
            if let data = image.jpegData(compressionQuality: 1.0) {
                try? data.write(to: fileURL)
            }
        }
    }
}
