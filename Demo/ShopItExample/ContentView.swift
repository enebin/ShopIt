//
//  ContentView.swift
//  ShopItExample
//
//  Created by Kai Lee on 3/21/25.
//

import SwiftUI
import ShopIt

struct ContentView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.shopitRedirector) private var redirector
    
    private let productName = "iPhone 16 pro"
    
    var body: some View {
        VStack(spacing: 20) {
            // Product Image (Placeholder image)
            Image("banner")
                .resizable()
                .scaledToFit()
            
            Text(productName)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            // You can use redirector to redirect to different shopping websites
            Button("Buy on Amazon") {
                Task {
                    try await redirector.redirect(keyword: productName, to: .amazonShopping)
                }
            }
            .buttonStyle(.borderedProminent)
            
            // It offers a more convenient way to redirect with predefined redirection
            Button("Buy on eBay") {
                Task {
                    try await redirector.redirect(keyword: productName, to: .ebay)
                    
                }
            }
            .buttonStyle(.borderedProminent)
            
            // You can also use the `RedirectButton` which is a custom button that handles redirection.
            // It also registers the `openURL` action inside automatically.
            RedirectButton(keyword: productName, redirection: .walmart) {
                Text("Buy on Walmart")
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .task {
            // !!!: YOU MUST register the openURL action first
            redirector.register(openURL)
        }
    }
}

#Preview {
    ContentView()
}

