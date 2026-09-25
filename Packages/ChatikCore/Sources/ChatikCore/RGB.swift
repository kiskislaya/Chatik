//
//  RGB.swift
//  ChatikCore
//
//  Created by Kseniya on 25.09.2026.
//

import Foundation

public struct RGB: Sendable, Hashable {
    public let r: UInt8
    public let g: UInt8
    public let b: UInt8
    
    public init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
    
    public init?(hex: String) {
        var hex = hex
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        guard hex.count == 6 else {
            return nil
        }
        if let v = UInt32(hex, radix: 16) {
            self.r = UInt8(truncatingIfNeeded: v >> 16)
            self.g = UInt8(truncatingIfNeeded: v >> 8)
            self.b = UInt8(truncatingIfNeeded: v)
        } else {
            return nil
        }
    }
}
