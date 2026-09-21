//
//  IRCTransport.swift
//  TwitchIRC
//
//  Created by Kseniya on 21.09.2026.
//

import Foundation

public protocol IRCTransport: Sendable {
    func connect() async throws
    func send(_ line: String) async throws
    func receive() async throws -> String
    func disconnect() async 
}
