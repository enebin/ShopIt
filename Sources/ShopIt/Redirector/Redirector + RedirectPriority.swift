//
//  RedirectPriority.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

public extension Redirector {
    /// The priority of redirection.
    enum RedirectPriority {
        /// Redirect to scheme URL first, then web URL.
        case scheme
        /// Redirect to web URL first, then scheme
        case web
    }
}
