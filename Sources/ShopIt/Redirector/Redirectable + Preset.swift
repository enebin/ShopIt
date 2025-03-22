//
//  Redirectable + Preset.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

import Foundation

// MARK: - Google
public struct GoogleSearchRedirection: Redirectable {
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

public extension Redirectable where Self == GoogleSearchRedirection {
    static var googleSearch: Self {
        GoogleSearchRedirection()
    }
}

// MARK: - Amazon Shopping
public struct AmazonShoppingRedirection: Redirectable {
    public let schemeUrl: QueryableURL
    public let webUrl: QueryableURL
    
    init() {
        self.schemeUrl = QueryableURL(
            baseURL: URL(string: "amazon://search")!
        ) { keyword in
            [URLQueryItem(name: "k", value: keyword)]
        }
        
        self.webUrl = QueryableURL(
            baseURL: URL(string: "https://www.amazon.com/s")!
        ) { keyword in
            [URLQueryItem(name: "k", value: keyword)]
        }
    }
}

public extension Redirectable where Self == AmazonShoppingRedirection {
    static var amazonShopping: Self {
        AmazonShoppingRedirection()
    }
}

// MARK: - eBay
public struct EbayRedirection: Redirectable {
    public let schemeUrl: QueryableURL
    public let webUrl: QueryableURL
    
    init() {
        self.schemeUrl = QueryableURL(
            baseURL: URL(string: "ebay://search")!
        ) { keyword in
            [URLQueryItem(name: "q", value: keyword)]
        }
        
        self.webUrl = QueryableURL(
            baseURL: URL(string: "https://www.ebay.com/sch/i.html")!
        ) { keyword in
            [URLQueryItem(name: "_nkw", value: keyword)]
        }
    }
}

public extension Redirectable where Self == EbayRedirection {
    static var ebay: Self {
        EbayRedirection()
    }
}

// MARK: - Walmart
public struct WalmartRedirection: Redirectable {
    public let schemeUrl: QueryableURL
    public let webUrl: QueryableURL
    
    init() {
        self.schemeUrl = QueryableURL(
            baseURL: URL(string: "walmart://search")!
        ) { keyword in
            [URLQueryItem(name: "query", value: keyword)]
        }
        
        self.webUrl = QueryableURL(
            baseURL: URL(string: "https://www.walmart.com/search/")!
        ) { keyword in
            [URLQueryItem(name: "query", value: keyword)]
        }
    }
}

public extension Redirectable where Self == WalmartRedirection {
    static var walmart: Self {
        WalmartRedirection()
    }
}

// MARK: - BestBuy
public struct BestBuyRedirection: Redirectable {
    public let schemeUrl: QueryableURL
    public let webUrl: QueryableURL
    
    init() {
        self.schemeUrl = QueryableURL(
            baseURL: URL(string: "bestbuy://search")!
        ) { keyword in
            [URLQueryItem(name: "query", value: keyword)]
        }
        
        self.webUrl = QueryableURL(
            baseURL: URL(string: "https://www.bestbuy.com/site/searchpage.jsp")!
        ) { keyword in
            [URLQueryItem(name: "st", value: keyword)]
        }
    }
}

public extension Redirectable where Self == BestBuyRedirection {
    static var bestBuy: Self {
        BestBuyRedirection()
    }
}

// MARK: - Coupang
public struct CoupangRedirection: Redirectable {
    public let schemeUrl: QueryableURL
    public let webUrl: QueryableURL
    
    init() {
        self.schemeUrl = QueryableURL(
            baseURL: URL(string: "coupang://search")!
        ) { keyword in
            [URLQueryItem(name: "q", value: keyword)]
        }
        
        self.webUrl = QueryableURL(
            baseURL: URL(string: "https://www.coupang.com/np/search")!
        ) { keyword in
            [URLQueryItem(name: "q", value: keyword)]
        }
    }
}

public extension Redirectable where Self == CoupangRedirection {
    static var coupang: Self {
        CoupangRedirection()
    }
}

// MARK: - MarketKurly
public struct MarketKurlyRedirection: Redirectable {
    public let schemeUrl: QueryableURL
    public let webUrl: QueryableURL
    
    init() {
        self.schemeUrl = QueryableURL(
            baseURL: URL(string: "kurly://search")!
        ) { keyword in
            [URLQueryItem(name: "q", value: keyword)]
        }
        
        self.webUrl = QueryableURL(
            baseURL: URL(string: "https://www.kurly.com/search")!
        ) { keyword in
            [URLQueryItem(name: "sword", value: keyword)]
        }
    }
}

public extension Redirectable where Self == MarketKurlyRedirection {
    static var marketKurly: Self {
        MarketKurlyRedirection()
    }
}

// MARK: - Naver Store
public struct NaverStoreRedirection: Redirectable {
    public let schemeUrl: QueryableURL
    public let webUrl: QueryableURL
    
    init() {
        self.schemeUrl = QueryableURL(
            baseURL: URL(string: "naversearchapp://inappbrowser")!
        ) { keyword in
            // Here we encode the query parameter into the URL value directly.
            [URLQueryItem(name: "url", value: "https://msearch.shopping.naver.com/search/all?query=\(keyword)")]
        }
        
        self.webUrl = QueryableURL(
            baseURL: URL(string: "https://msearch.shopping.naver.com/search/all")!
        ) { keyword in
            [URLQueryItem(name: "query", value: keyword)]
        }
    }
}

public extension Redirectable where Self == NaverStoreRedirection {
    static var naverStore: Self {
        NaverStoreRedirection()
    }
}
