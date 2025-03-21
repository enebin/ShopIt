//
//  ContentView.swift
//  ShopItExample
//
//  Created by Kai Lee on 3/21/25.
//

import SwiftUI
import ShopIt

struct ContentView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.redirector) var redirector
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            redirector.register(openURL)
            try? await redirector.redirect(keyword: "test", to: .googleSearch)
        }
    }
}

#Preview {
    ContentView()
}
