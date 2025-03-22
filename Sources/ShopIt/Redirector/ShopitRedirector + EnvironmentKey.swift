//
//  RedirectorKey.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

import SwiftUI
private struct RedirectorKey: EnvironmentKey {
    static let defaultValue: ShopitRedirector = ShopitRedirector.shared
}

public extension EnvironmentValues {
    /// Environment value to access `ShopitRedirector` in SwiftUI view.
    var shopitRedirector: ShopitRedirector {
        get { self[RedirectorKey.self] }
        set { self[RedirectorKey.self] = newValue }
    }
}
