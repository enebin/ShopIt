//
//  GoogleRedirectable.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

import Foundation

// MARK: - Google Search
public extension Redirectable where Self == GoogleRedirection {
    static var googleSearch: Self {
        GoogleRedirection()
    }
}

public struct GoogleRedirection: Redirectable {
    public let schemeUrl: QueryableURL
    public let webUrl: QueryableURL
    
    init() {
        self.schemeUrl = QueryableURL(
            baseURL: URL(string: "https://www.google.com/search")!
        ) { keyword in
            [URLQueryItem(name: "q", value: keyword)]
        }
        
        self.webUrl = QueryableURL(
            baseURL: URL(string: "google://search")!
        ) { keyword in
            [URLQueryItem(name: "q", value: keyword)]
        }
    }
}
