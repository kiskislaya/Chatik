//
//  IRCMessage.swift
//  TwitchIRC
//
//  Created by Kseniya on 21.09.2026.
//

import Foundation

struct IRCMessage: Sendable, Equatable {
    let prefix: String?
    let command: String
    let params: [String]
    let trailing: String?
    
    init(parsing line: String) throws {
        throw IRCParseError.missingCommand
    }
}

enum IRCParseError: Error, Equatable {
    case emptyLine
    case missingCommand
}
