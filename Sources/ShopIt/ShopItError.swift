//
//  ShopItError.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

import Foundation

enum ShopItError: LocalizedError {
    case invalidURL
    case openUrlActionNotSet
    case cannotOpenURL
}

extension ShopItError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .openUrlActionNotSet:
            return "Open URL action is not set. Please set it with `ShopitRedirector.register` before using."
        case .cannotOpenURL:
            return "Cannot open URL"
        }
    }
}
