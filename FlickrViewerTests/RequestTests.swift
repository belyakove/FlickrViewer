//
//  RequestTests.swift
//  FlickrViewerTests
//
//  Created by Eugene Belyakov on 07/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import XCTest
@testable import FlickrViewer

class RequestTests: XCTestCase {


    func testInitialSearchRequest() {
        let request = SearchRequest("kitten")
        
        let expected = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=kitten")
        XCTAssertEqual(request.url, expected)
    }

    func testPageSearchRequest() {
        let request = SearchRequest("kitten", page: 3)
        
        let expected = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=kitten&page=3")
        XCTAssertEqual(request.url, expected)
    }

    func testPhotoRequest() {
        let photo = PhotoModel(id: "test_id",
                               owner: "",
                               secret: "test_secret",
                               server: "test_server",
                               farm: 42,
                               title: "")
        let request = PhotoRequest(photoModel: photo)
        let expected = URL(string: "http://farm42.static.flickr.com/test_server/test_id_test_secret.jpg")
        XCTAssertEqual(request.url, expected)
    }

}
