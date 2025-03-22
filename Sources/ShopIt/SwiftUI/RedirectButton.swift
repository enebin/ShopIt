//
//  RedirectButton.swift
//  ShopIt
//
//  Created by Kai Lee on 3/22/25.
//

import SwiftUI

/// A button that redirects to a specific URL when tapped
///
/// - Note: It automatically registers the `openURL` action in the `ShopitRedirector` environment.
public struct RedirectButton<Content, Redirection>: View
where Content: View, Redirection: Redirectable
{
    @Environment(\.openURL) private var openURL
    @Environment(\.shopitRedirector) private var redirector
    
    private let content: () -> Content
    private let keyword: String
    private let redirection: Redirection
        
    /// Creates a button that redirects to a specific URL when tapped
    public init(keyword: String, redirection: Redirection, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.keyword = keyword
        self.redirection = redirection
    }
    
    public var body: some View {
        Button(
            action: {
                Task {
                    do {
                        try await redirector.redirect(keyword: keyword, to: redirection)
                    } catch {
                        print("🚨 [ShopIt] Error occurs: \(error.localizedDescription)")
                    }
                }
            },
            label: content
        )
        .task {
            if redirector.openUrlAction == nil {
                redirector.register(openURL)
            }
        }
    }
}
