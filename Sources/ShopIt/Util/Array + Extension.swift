//
//  Array + Extension.swift
//  ShopIt
//
//  Created by Kai Lee on 3/21/25.
//

import Foundation

extension Array {
    var second: Element? {
        guard count > 1 else { return nil }
        return self[1]
    }
}
