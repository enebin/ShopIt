//
//  RedirectorTests.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

@testable import ShopIt
import Testing
import SwiftUI

@Suite(.serialized) class RedirectorTests {
    let redirector: Redirector
    let mockBothRedirection: MockBothRedirection
    let mockWebRedirection: MockWebRedirection

    init() {
        self.redirector = Redirector.shared
        self.mockBothRedirection = MockBothRedirection()
        self.mockWebRedirection = MockWebRedirection()
    }
    
    deinit {
        redirector.unregister()
    }
    
    // MARK: - Registering
    @Test func register() async throws {
        let openUrlAction = await OpenURLAction(handler: { _ in return .handled })
        redirector.register(opener: openUrlAction)
        
        try await redirector.redirect(keyword: "test", to: mockBothRedirection)
    }
    
    
    @Test func notRegistered() async {
        await #expect(throws: ShopItError.openUrlActionNotSet) {
            try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        }
    }
    
    @Test func registerAndThenUnregister() async throws {
        let openUrlAction = await OpenURLAction(handler: { _ in return .handled })
        redirector.register(opener: openUrlAction)
        
        // No throw
        try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        
        // Should throw
        redirector.unregister()
        await #expect(throws: ShopItError.openUrlActionNotSet) {
            try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        }
    }
    
    // MARK: - Redirecting
    @Test func redirectWhenBothAvailable() async throws {
        let openUrlAction = await OpenURLAction(handler: { _ in return .handled })
        redirector.register(opener: openUrlAction)
        
        var mockBothRedirection = MockBothRedirection()
        try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        
        #expect(mockBothRedirection.schemeUrlCalled == 1)
        #expect(mockBothRedirection.webUrlCalled == 0)

        mockBothRedirection = MockBothRedirection()
        redirector.redirectPriority(.web)
        try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        
        #expect(mockBothRedirection.webUrlCalled == 1)
        #expect(mockBothRedirection.schemeUrlCalled == 0)
    }
    
    @Test func failToRedirectFirstTrial() async throws {
        var isHandled = false
        let openUrlAction = await OpenURLAction(handler: { _ in
            defer { isHandled = true }
            return isHandled ? .handled : .discarded
        })
        
        redirector.register(opener: openUrlAction)
        
        try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        
        #expect(mockBothRedirection.schemeUrlCalled == 1)
        #expect(mockBothRedirection.webUrlCalled == 1)
    }
    
    @Test func failToOpenUrl() async {
        let openUrlAction = await OpenURLAction(handler: { _ in return .discarded })
        redirector.register(opener: openUrlAction)
        
        await #expect(throws: ShopItError.cannotOpenURL) {
            try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        }
    }
    
    // MARK: - Redirecting to Specific URL
    @Test func redirectToScheme() async throws {
        let openUrlAction = await OpenURLAction(handler: { _ in return .handled })
        redirector.register(opener: openUrlAction)
        
        let mockSchemeRedirection = MockSchemeRedirection()
        try await redirector.redirect(keyword: "test", to: mockSchemeRedirection)
        
        #expect(mockSchemeRedirection.schemeUrlCalled == 1)
    }
    
    @Test func redirectToWeb() async throws {
        let openUrlAction = await OpenURLAction(handler: { _ in return .handled })
        redirector.register(opener: openUrlAction)
        
        let mockWebRedirection = MockWebRedirection()
        try await redirector.redirect(keyword: "test", to: mockWebRedirection)
        
        #expect(mockWebRedirection.webUrlCalled == 1)
    }
}

extension RedirectorTests {
    class MockBothRedirection: Redirectable {
        private(set) var schemeUrlCalled = 0
        private(set) var webUrlCalled = 0
        
        var schemeUrl: QueryableURL {
            schemeUrlCalled += 1
            return QueryableURL(baseURL: URL(string: "mock://")!) { [URLQueryItem(name: "item", value: $0)] }
        }
        
        var webUrl: QueryableURL {
            webUrlCalled += 1
            return QueryableURL(baseURL: URL(string: "https://www.mock.com/")!) { [URLQueryItem(name: "item", value: $0)] }
        }
    }
    
    class MockSchemeRedirection: SchemeRedirectable {
        private(set) var schemeUrlCalled = 0
        
        var schemeUrl: QueryableURL {
            schemeUrlCalled += 1
            return QueryableURL(baseURL: URL(string: "mock://")!) { [URLQueryItem(name: "item", value: $0)] }
        }
    }
    
    class MockWebRedirection: WebRedirectable {
        private(set) var webUrlCalled = 0
        
        var webUrl: QueryableURL {
            webUrlCalled += 1
            return QueryableURL(baseURL: URL(string: "https://www.mock.com/")!) { [URLQueryItem(name: "item", value: $0)] }
        }
    }
}
