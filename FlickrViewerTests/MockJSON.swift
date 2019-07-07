//
//  MockJSON.swift
//  FlickrViewerTests
//
//  Created by Eugene Belyakov on 07/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

class MockJSON: NSObject {
    class func jsonWithName(_ name: String) -> Data {
        
        guard let path = Bundle(for: MockJSON.self).path(forResource: name, ofType: nil) else {
            fatalError("Can't load json file: \(name)")
        }
        let url = URL(fileURLWithPath: path)
        return try! Data(contentsOf: url)
    }
    
    class var photoJsonData: Data {
        return jsonWithName("Photo.json")
    }
    
    class var stringBucketJsonData: Data {
        return jsonWithName("StringBucket.json")
    }
    
    class var intBucketJsonData: Data {
        return jsonWithName("IntBucket.json")
    }
    
    class var invalidBucketJsonData: Data {
        return jsonWithName("InvalidBucket.json")
    }
    
    class var searchJsonData: Data {
        return jsonWithName("Search.json")
    }

}
