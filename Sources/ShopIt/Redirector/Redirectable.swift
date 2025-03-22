//
//  Redirectable.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

import SwiftUI

/// A type that can be redirected to a scheme URL.
public protocol SchemeRedirectable {
    /// Optional URL configuration for app-specific scheme redirection.
    var schemeUrl: QueryableURL { get }
}

/// A type that can be redirected to a web URL.
public protocol WebRedirectable {
    /// URL configuration for web page redirection.
    var webUrl: QueryableURL { get }
}

/// A type that can redirect to either a scheme URL or a web URL.
public protocol Redirectable: SchemeRedirectable & WebRedirectable {}
