//
//  RedirectorKey.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

import SwiftUI
private struct RedirectorKey: EnvironmentKey {
    static let defaultValue: Redirector = Redirector.shared
}

public extension EnvironmentValues {
    /// Environment value to access `Redirector` in SwiftUI view.
    var redirector: Redirector {
        get { self[RedirectorKey.self] }
        set { self[RedirectorKey.self] = newValue }
    }
}
