//
//  Redirector.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

import SwiftUI

public final class Redirector {
    static public let shared = Redirector()
    
    private var openUrlAction: OpenURLAction?
    
    /// The priority of redirection.
    ///
    /// - Note: The default value is `.scheme`
    public private(set) var redirectPriority: RedirectPriority = .scheme
    
    // MARK: - Init
    /// Hidden initializer
    init() {}
    
    // MARK: - Registering
    /// Registers a URL opener action.
    public func register(opener: OpenURLAction) {
        openUrlAction = opener
    }
    
    /// Unregisters the URL opener action.
    public func unregister() {
        openUrlAction = nil
    }
    
    // MARK: - Redirecting
    /// Redirects to the scheme URL using a keyword.
    public func redirect(keyword: String, to redirection: some SchemeRedirectable) async throws {
        try await openLink(using: redirection.schemeUrl, keyword: keyword)
    }
    
    /// Redirects to the web URL using a keyword.
    public func redirect(keyword: String, to redirection: some WebRedirectable) async throws {
        try await openLink(using: redirection.webUrl, keyword: keyword)
    }
    
    /// Redirects to a specific URL using a keyword.
    ///
    /// First link to be opened is determined by the `redirectPriority` property.
    /// If the first link fails to open, the other link is attempted
    public func redirect(keyword: String, to redirection: some Redirectable) async throws {
        if redirectPriority == .scheme {
            do {
                try await openLink(using: redirection.schemeUrl, keyword: keyword)
            } catch {
                try await openLink(using: redirection.webUrl, keyword: keyword)
            }
        } else {
            do {
                try await openLink(using: redirection.webUrl, keyword: keyword)
            } catch {
                try await openLink(using: redirection.schemeUrl, keyword: keyword)
            }
        }
    }
    
    // MARK: - Config
    /// Sets the redirect
    ///
    /// - Note: The default value is `.scheme`
    @discardableResult
    public func redirectPriority(_ priority: RedirectPriority) -> Redirector {
        redirectPriority = priority
        return self
    }
}

// MARK: - Private
private extension Redirector {
    func openLink(using queryable: QueryableURL, keyword: String) async throws {
        guard let url = queryable.url(with: keyword) else {
            throw ShopItError.invalidURL
        }
        
        try await performOpenUrlAction(url)
    }
    
    func performOpenUrlAction(_ url: URL) async throws  {
        guard let openUrlAction else {
            throw ShopItError.openUrlActionNotSet
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                openUrlAction(url) { accepted in
                    if accepted {
                        continuation.resume(returning: ())
                    } else {
                        continuation.resume(throwing: ShopItError.cannotOpenURL)
                    }
                }
            }
        }
    }
}
