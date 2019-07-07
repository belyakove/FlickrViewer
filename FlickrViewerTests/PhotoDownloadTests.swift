//
//  PhotoDownloadTests.swift
//  FlickrViewerTests
//
//  Created by Eugene Belyakov on 07/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import XCTest
@testable import FlickrViewer

extension PhotoModel {
    static var empty: PhotoModel {
        return PhotoModel(id: "", owner: "", secret: "", server: "", farm: 0, title: "")
    }
}

class MockCache: CacheService {

    var image: UIImage?
    
    func loadCachedImageForIdentifier(_ identifier: String, completionHandler: @escaping LoadImageCompletionHandler) {
        completionHandler(image)
    }

    func cache(image: UIImage, forIdentifier identifier: String) {}
}

class PhotoDownloadTests: XCTestCase {

    func imageData() -> Data? {
        let path = Bundle(for: PhotoDownloadTests.self).url(forResource: "image", withExtension: "jpg")!
        return try? Data(contentsOf: path)
    }
    
    func image() -> UIImage? {
        return UIImage(data: imageData() ?? Data())
    }
    
    func testPhotoDownload() {
        
        let api = MockAPIService()
        let photoDownloadService = PhotoDownloadService(api: api, cache: MockCache())
        api.data = imageData()
        
        let exp = expectation(description: "Photo load")
        var resultImage: UIImage?
        var resultError: Error?
        
        let _ = photoDownloadService.loadPhoto(PhotoModel.empty) { (image, error) in
            resultImage = image
            resultError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNotNil(resultImage)
        XCTAssertNil(resultError)
    }
    
    func testFailedPhotoDownload() {
        
        let api = MockAPIService()
        let photoDownloadService = PhotoDownloadService(api: api, cache: MockCache())
        
        let exp = expectation(description: "Photo load")
        var resultImage: UIImage?
        var resultError: Error?
        
        let _ = photoDownloadService.loadPhoto(PhotoModel.empty) { (image, error) in
            resultImage = image
            resultError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNil(resultImage)
        XCTAssertNotNil(resultError)
    }

    
    func testPhotoFromCache() {
        
        let api = MockAPIService()
        let mockCache = MockCache()
        let image = self.image()
        mockCache.image = image
        let photoDownloadService = PhotoDownloadService(api: api, cache: mockCache)
        
        let exp = expectation(description: "Photo load from cache")
        var resultImage: UIImage?
        var resultError: Error?
        
        let _ = photoDownloadService.loadPhoto(PhotoModel.empty) { (image, error) in
            resultImage = image
            resultError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNil(resultError)
        XCTAssertTrue(resultImage === mockCache.image)
    }

}
