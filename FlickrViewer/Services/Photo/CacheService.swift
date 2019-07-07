//
//  CacheService.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 05/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

typealias LoadImageCompletionHandler = (UIImage?) -> Void

/* Cache service uses caches directory for storing
 image files so for this task relying on iOS behaviour
 for cleaning obsolete data */

protocol CacheService {
    func loadCachedImageForIdentifier(_ identifier: String, completionHandler: @escaping LoadImageCompletionHandler)
    func cache(image: UIImage, forIdentifier identifier: String)
}
