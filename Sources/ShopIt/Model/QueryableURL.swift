//
//  QueryableURL.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

import Foundation

/// A struct that encapsulates a base URL and a query builder closure.
///
/// The `QueryableURL` structure provides a flexible way to construct URLs by appending query items generated from a keyword.
///
/// - Note: The resulting URL is generated by combining the base URL and the query items produced by the query builder
public struct QueryableURL {
    /// The base URL used as the foundation for URL construction.
    public let baseURL: URL
    
    /// A closure that generates query items based on a given keyword.
    public let queryBuilder: (String) -> [URLQueryItem]
    
    /// Constructs a complete URL by appending query items derived from the provided keyword to the base URL.
    ///
    /// This method uses `URLComponents` to safely append the query items to the base URL. If the base URL cannot be decomposed into components, the method returns `nil`.
    ///
    /// - Parameter keyword: The keyword used to generate the query items.
    /// - Returns: An optional `URL` object containing the combined base URL and query items.
    public func url(with keyword: String) -> URL? {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        let newQueryItems = queryBuilder(keyword)
        components.queryItems = (components.queryItems ?? []) + newQueryItems
        
        return components.url
    }
}
