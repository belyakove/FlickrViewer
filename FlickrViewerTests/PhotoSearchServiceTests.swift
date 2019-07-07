//
//  PhotoSearchServiceTests.swift
//  FlickrViewerTests
//
//  Created by Eugene Belyakov on 07/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import XCTest
@testable import FlickrViewer


class PhotoSearchServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccesfulPhotoSearch() {
        let api = MockAPIService()
        api.result = try? JSONDecoder().decode(SearchResponseModel.self,
                                              from: MockJSON.searchJsonData)
        let photoSearchService = PhotoSearchService(api: api)
        
        let exp = expectation(description: "Search result")
        
        var resultBucket: BucketModel?
        var resultError: Error?
        
        let _ = photoSearchService.loadBucketForSearchTerm("search") { (bucket, error) in
            resultBucket = bucket
            resultError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        XCTAssertNil(resultError)
        XCTAssertEqual(resultBucket?.photos.count, 2)
    }
    
    func testErrorPhotoSearch() {
        let api = MockAPIService()
        api.error = URLError(.badURL)
        let photoSearchService = PhotoSearchService(api: api)
        
        let exp = expectation(description: "Search result")
        
        var resultBucket: BucketModel?
        var resultError: Error?
        
        let _ = photoSearchService.loadBucketForSearchTerm("search") { (bucket, error) in
            resultBucket = bucket
            resultError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        XCTAssertNil(resultBucket)
        
        guard let error = resultError else {
            XCTFail("Error not delivered")
            return
        }
        if case URLError.badURL = error {
        } else {
            XCTFail("Incorrect error delivered")
        }
        
    }
    
    func testEmptyPhotoSearch() {
        let api = MockAPIService()
        let photoSearchService = PhotoSearchService(api: api)
        
        let exp = expectation(description: "Search result")
        
        var resultBucket: BucketModel?
        var resultError: Error?
        
        let _ = photoSearchService.loadBucketForSearchTerm("search") { (bucket, error) in
            resultBucket = bucket
            resultError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        XCTAssertNil(resultBucket)
        
        guard let error = resultError else {
            XCTFail("Error not delivered")
            return
        }
        if case URLError.badServerResponse = error {
        } else {
            XCTFail("Incorrect error delivered")
        }
        
    }



}
