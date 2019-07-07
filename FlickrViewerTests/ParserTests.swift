//
//  ParserTests.swift
//  FlickrViewerTests
//
//  Created by Eugene Belyakov on 07/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import XCTest
@testable import FlickrViewer

class ParserTests: XCTestCase {

    let jsonDecoder = JSONDecoder()
    
    func testPhotoParsing() {
        XCTAssertNoThrow(try self.jsonDecoder.decode(PhotoModel.self, from: MockJSON.photoJsonData))
        guard let photoModel = try? self.jsonDecoder.decode(PhotoModel.self, from: MockJSON.photoJsonData) else {
            XCTFail("Can't parse photo JSON")
            return
        }
        XCTAssertEqual(photoModel.id, "48189399141")
    }


    func checkBuketWithData(_ data: Data) {
        XCTAssertNoThrow(try self.jsonDecoder.decode(BucketModel.self, from: data))
        guard let bucketModel = try? self.jsonDecoder.decode(BucketModel.self, from: data) else {
            XCTFail("Can't parse bucket JSON")
            return
        }
        XCTAssertEqual(bucketModel.page, 1)
        XCTAssertEqual(bucketModel.pages, 1666)
        XCTAssertEqual(bucketModel.perpage, 100)
        XCTAssertEqual(bucketModel.total, 166527)
    }
    
    func testBucketWithIntValues() {
        self.checkBuketWithData(MockJSON.intBucketJsonData)
    }

    func testBucketWithStringValues() {
        self.checkBuketWithData(MockJSON.stringBucketJsonData)
    }
    
    func testInvalidBucket() {
        XCTAssertThrowsError(try self.jsonDecoder.decode(BucketModel.self, from: MockJSON.invalidBucketJsonData))
    }

    func testSearchParsing() {
        XCTAssertNoThrow(try self.jsonDecoder.decode(SearchResponseModel.self, from: MockJSON.searchJsonData))
        guard let searchResponse = try? self.jsonDecoder.decode(SearchResponseModel.self, from: MockJSON.searchJsonData) else {
            XCTFail("Can't parse search result JSON")
            return
        }
        XCTAssertEqual(searchResponse.status, "ok")
        XCTAssertEqual(searchResponse.bucket.pages, 1666)
    }
}
