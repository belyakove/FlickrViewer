//
//  PhotoDataSourceTests.swift
//  FlickrViewerTests
//
//  Created by Eugene Belyakov on 07/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import XCTest
@testable import FlickrViewer

class MockDataSourceDelegate: PhotoDataSourceDelegate {
    
    var didUpdateBlock: (() -> Void)?
    var didLoadMoreBlock: ((Range<Int>) -> Void)?
    
    func photoSourceDidUpdateBucket(_ source: PhotoDataSource) {
        didUpdateBlock?()
    }
    
    func photoSource(_ source: PhotoDataSource, didLoadMorePhotosInRange range: Range<Int>) {
        didLoadMoreBlock?(range)
    }
}

class PhotoDataSourceTests: XCTestCase {

    func testPhotoSource() {
        
        let api = MockAPIService()
        api.result = try! JSONDecoder().decode(SearchResponseModel.self, from: MockJSON.searchJsonData)
        let photoSearchService = PhotoSearchService(api: api)
        let photoDataSource = PhotoDataSource(photoService: photoSearchService)
        
        
        let delegate = MockDataSourceDelegate()
        photoDataSource.delegate = delegate


        let updateExp = expectation(description: "Load")
        delegate.didUpdateBlock = {
            updateExp.fulfill()
        }
        
        photoDataSource.searchTerm = "test search"
        
        wait(for: [updateExp], timeout: 1)
        XCTAssertEqual(photoDataSource.photos.count, 2)
        
        let loadMoreExp = expectation(description: "Load more")
        var resultRange: Range<Int>?
        delegate.didLoadMoreBlock = { (range) in
            resultRange = range
            loadMoreExp.fulfill()
        }
        
        photoDataSource.loadMoreIfPresent()
        
        wait(for: [loadMoreExp], timeout: 1)
        
        XCTAssertEqual(resultRange, 2..<4)
        XCTAssertEqual(photoDataSource.photos.count, 4)
        
        delegate.didUpdateBlock = nil
        photoDataSource.searchTerm = ""
        
        XCTAssertEqual(photoDataSource.photos.count, 0)
    }
}
