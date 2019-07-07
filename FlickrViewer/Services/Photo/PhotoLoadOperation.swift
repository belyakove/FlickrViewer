//
//  PhotoLoadOperation.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 05/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

extension PhotoLoadOperation: Cancellable {}

class PhotoLoadOperation: Operation {
    
    private enum Status {
        case pending
        case running
        case finished
    }
    
    private var internalStatus: Status
    private var status: Status {
        set {
            self.syncQueue.async {
                
                let oldKey = self.keyPathFor(status: self.internalStatus)
                let newKey = self.keyPathFor(status: newValue)
                
                self.willChangeValue(for: oldKey)
                self.willChangeValue(for: newKey)
                self.internalStatus = newValue
                self.didChangeValue(for: newKey)
                self.didChangeValue(for: oldKey)
            }
        }
        get {
            return self.internalStatus
        }
    }
    
    private let api: APIService
    private let cache: CacheService
    private let photo: PhotoModel
    private let syncQueue: DispatchQueue
    
    var result: UIImage?
    var error: Error?
    
    private var internalNetworkRequest: Cancellable?
    private var networkRequest: Cancellable? {
        set {
            self.syncQueue.async {
                self.internalNetworkRequest = newValue
            }
        }
        get {
            var value: Cancellable? = nil
            self.syncQueue.sync {
                value = self.internalNetworkRequest
            }
            return value
        }
    }
    
    init(api: APIService, cache: CacheService, photo: PhotoModel, syncQueue: DispatchQueue) {
        self.api = api
        self.cache = cache
        self.photo = photo
        self.syncQueue = syncQueue
        self.internalStatus = .pending
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return self.status == .pending
    }
    
    override var isExecuting: Bool {
        return self.status == .running
    }
    
    override var isFinished: Bool {
        return self.status == .finished
    }
    
    override func start() {
        guard self.isReady else {
            return
        }
        
        guard !self.isCancelled else {
            self.status = .finished
            return
        }
        
        self.status = .running
        self.loadPhoto(self.photo)
    }
    
    override func cancel() {
        super.cancel()
        self.networkRequest?.cancel()
    }
    
    func finishWithResult(_ image: UIImage) {
        self.result = image
        self.status = .finished
    }
    
    func finishWithError(_ error: Error?) {
        self.error = error
        self.status = .finished
    }
    
    func finishIfCancelled() -> Bool {
        if self.isCancelled {
            self.finishWithError(URLError(.cancelled))
            return true
        }
        return false
    }
    
    func loadPhoto(_ photo: PhotoModel) {
        
        self.cache.loadCachedImageForIdentifier(photo.cacheIdentifier) { (image) in
            if let image = image {
                
                self.finishWithResult(image)
                
            } else {
                
                guard !self.finishIfCancelled() else { return }
                
                let request = PhotoRequest(photoModel: photo)
                
                self.networkRequest = self.api.executeRequest(request, completionHandler: { (data, error) in

                    guard !self.finishIfCancelled() else { return }

                    if let data = data, let image = UIImage(data: data) {
                        self.cache.cache(image: image, forIdentifier: photo.cacheIdentifier)
                        self.finishWithResult(image)
                    } else {
                        self.finishWithError(error ?? URLError(.badServerResponse))
                    }
                })
            }
        }
    }
    
    private func keyPathFor(status: Status) -> KeyPath<PhotoLoadOperation, Bool> {
        
        switch status {
        case .pending:
            return \.isReady
        case .running:
            return \.isExecuting
        case .finished:
            return \.isFinished
        }
    }
}
