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
    private let redirector: ShopitRedirector
    private let mockBothRedirection: MockBothRedirection

    init() {
        self.redirector = ShopitRedirector.shared
        self.mockBothRedirection = MockBothRedirection()
    }
    
    deinit {
        redirector.unregister()
    }
    
    // MARK: - Registering
    @Test func register() async throws {
        let spy = OpenURLSpy()
        redirector.register(spy.getAction())
        
        try await redirector.redirect(keyword: "test", to: mockBothRedirection)
    }
    
    
    @Test func notRegistered() async {
        await #expect(throws: ShopItError.openUrlActionNotSet) {
            try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        }
    }
    
    @Test func registerAndThenUnregister() async throws {
        let spy = OpenURLSpy()
        redirector.register(spy.getAction())
        
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
        let spy = OpenURLSpy()
        redirector.register(spy.getAction())
        
        let schemeRedirection = MockSchemeRedirection()
        try await redirector.redirect(keyword: "test", to: schemeRedirection)
        
        #expect(spy.schemeUrlOpened == 1)
        #expect(spy.webUrlOpened == 0)
        
        spy.reset()
        
        let webRedirection = MockWebRedirection()
        try await redirector.redirect(keyword: "test", to: webRedirection)
        
        #expect(spy.schemeUrlOpened == 0)
        #expect(spy.webUrlOpened == 1)
    }
    
    @Test func failToRedirectFirstTrial() async throws {
        let spy = OpenURLSpy(deliberateFailure: 1)
        redirector.register(spy.getAction())
        
        try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        
        #expect(spy.schemeUrlOpened == 1)
        #expect(spy.webUrlOpened == 1)
    }
    
    @Test func failToOpenUrl() async {
        let spy = OpenURLSpy(deliberateFailure: .forever)
        redirector.register(spy.getAction())
        
        await #expect(throws: ShopItError.cannotOpenURL) {
            try await redirector.redirect(keyword: "test", to: mockBothRedirection)
        }
    }
    
    // MARK: - Redirecting to Specific URL
    @Test func redirectToScheme() async throws {
        let spy = OpenURLSpy()
        redirector.register(spy.getAction())
        
        let mockSchemeRedirection = MockSchemeRedirection()
        try await redirector.redirect(keyword: "test", to: mockSchemeRedirection)
        
        #expect(spy.schemeUrlOpened == 1)
    }
    
    @Test func redirectToWeb() async throws {
        let spy = OpenURLSpy()
        redirector.register(spy.getAction())
        
        let mockWebRedirection = MockWebRedirection()
        try await redirector.redirect(keyword: "test", to: mockWebRedirection)
        
        #expect(spy.webUrlOpened == 1)
    }
}

private extension RedirectorTests {
    class OpenURLSpy {
        private let schemePrefix: String
        private var deliberateFailure: Int?
        
        private var handler: OpenURLAction
        
        private(set) var schemeUrlOpened = 0
        private(set) var webUrlOpened = 0
                
        init(schemePrefix: String = "mock://", deliberateFailure: Int? = nil) {
            self.schemePrefix = schemePrefix
            self.deliberateFailure = deliberateFailure
            self.handler = OpenURLAction { _ in return .handled }
        }
        
        func getAction() -> OpenURLAction {
            self.handler = OpenURLAction { url in
                if url.absoluteString.hasPrefix(self.schemePrefix) {
                    self.schemeUrlOpened += 1
                } else {
                    self.webUrlOpened += 1
                }
                
                return self.returnStatus()
            }
            
            return handler
        }
        
        func reset() {
            schemeUrlOpened = 0
            webUrlOpened = 0
        }
        
        private func returnStatus() -> OpenURLAction.Result {
            if let failure = deliberateFailure {
                if failure > 0 {
                    deliberateFailure = failure - 1
                    return .discarded
                }
            }
            
            return .handled
        }
    }
    
    class MockBothRedirection: Redirectable {
        var schemeUrl: QueryableURL {
            QueryableURL(baseURL: URL(string: "mock://")!) { [URLQueryItem(name: "item", value: $0)] }
        }
        
        var webUrl: QueryableURL {
            QueryableURL(baseURL: URL(string: "https://www.mock.com/")!) { [URLQueryItem(name: "item", value: $0)] }
        }
    }
    
    class MockSchemeRedirection: SchemeRedirectable {
        var schemeUrl: QueryableURL {
            QueryableURL(baseURL: URL(string: "mock://")!) { [URLQueryItem(name: "item", value: $0)] }
        }
    }
    
    class MockWebRedirection: WebRedirectable {
        var webUrl: QueryableURL {
            QueryableURL(baseURL: URL(string: "https://www.mock.com/")!) { [URLQueryItem(name: "item", value: $0)] }
        }
    }
}

private extension Int? {
    static var forever: Int { Int.max }
}
