//
//  KeyedDecodingContainer+JSON.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

/* In JSON response sometimes numbers are represented as
 strings. Even for same request with different parameters
 same fields might be represented with different types.
 This extension for decoder is emplemeted to handle
 this case. */

extension KeyedDecodingContainer {
    func decodeJSONInt(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int  {
        if let value = try? self.decode(String.self, forKey: key) {
            if let result = Int(value) {
                return result
            } else {
                throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Payload is neither Int or int representable string"))
            }
        } else {
            return try self.decode(Int.self, forKey: key)
        }
    }
}
