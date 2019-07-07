//
//  PhotoDataSource.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 04/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

protocol PhotoDataSourceDelegate: class {
    func photoSourceDidUpdateBucket(_ source: PhotoDataSource)
    func photoSource(_ source: PhotoDataSource, didLoadMorePhotosInRange range: Range<Int>)
}

/* Class responsible for managing of surrent search state and
 paging behaviour. */

/* For the sake of simplicity syncing callbacks against
 the main queue. In this case it is ok because work performed
 on the main queue is lightweight. Better would be to
 introduce internal serial synchronization queue and perform synchronization
on it. */

class PhotoDataSource: NSObject {
    
    weak var delegate: PhotoDataSourceDelegate?
    
    private var loadMoreNetworkRequest: Cancellable?
    
    private let photoService: PhotoSearchService
    private var bucket: BucketModel? {
        didSet {
            self.photos = self.bucket?.photos ?? []
            self.delegate?.photoSourceDidUpdateBucket(self)
        }
    }
    
    private var currentBucketRequest: Cancellable?
    
    init(photoService: PhotoSearchService) {
        self.photoService = photoService
    }
    
    var photos: [PhotoModel] = []
    
    var moreAvailable: Bool {
        if let bucket = self.bucket {
            return self.photos.count < bucket.total
        }
        return false
    }
    
    var searchTerm: String? {
        didSet {
            if let searchTerm = self.searchTerm, !searchTerm.isEmpty {
                self.loadBucketFor(searchTerm)
            } else {
                self.currentBucketRequest?.cancel()
                self.currentBucketRequest = nil
                self.bucket = nil
            }
        }
    }
    
    func loadBucketFor(_ searchTerm: String) {
        self.loadMoreNetworkRequest?.cancel()
        self.currentBucketRequest?.cancel()
        self.currentBucketRequest = self.photoService.loadBucketForSearchTerm(searchTerm, completion: { (bucket, error) in
            
            if let error = error {
                if case URLError.cancelled = error  {
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.bucket = bucket
                self.currentBucketRequest = nil
            }
        })
    }
    
    func loadMoreIfPresent() {
        guard let bucket = self.bucket,
            let searchTerm = self.searchTerm,
            self.moreAvailable,
            self.loadMoreNetworkRequest == nil else {
                return
        }
        
        let nextPage = photos.count / bucket.perpage + 1
        
        self.loadMoreNetworkRequest = self.photoService.loadBucketForSearchTerm(searchTerm, page: nextPage) { (bucket, error) in

            DispatchQueue.main.async {
                self.loadMoreNetworkRequest = nil
                if let photos = bucket?.photos {
                    let range = self.photos.count..<self.photos.count + photos.count
                    self.photos.append(contentsOf: photos)
                    self.delegate?.photoSource(self, didLoadMorePhotosInRange: range)
                }
            }
        }
        
    }
    
}
