//
//  SearchRequest.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

struct SearchRequest: APIObjectRequest {
    
    typealias Result = SearchResponseModel
    
    let searchString: String
    let page: Int
    
    init(_ searchString:String, page: Int = 0) {
        self.searchString = searchString
        self.page = page
    }
    
    /* For the sake of simplicity implemeted URL generation like below.
     For real application case I would separate parameters from the base address
     and would generate full URL later. */
    var url: URL {
        let escapedSearchTerm = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? searchString
        var urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=\(escapedSearchTerm)"
        
        if self.page != 0 {
           urlString.append("&page=\(self.page)")
        }
        
        return URL(string: urlString)! //Not very safe way but in this case we know the string exactly
    }
}
