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
        var rest = line[...]
        let prefix: String?
        let command: String
        var params: [String] = []
        var trailing: String?
        guard !rest.isEmpty else {
            throw IRCParseError.emptyLine
        }
        if rest.first == ":" {
            rest = rest.dropFirst()
            guard let pref = takeWord(from: &rest) else {
                throw IRCParseError.missingCommand
            }
            prefix = pref
        } else {
            prefix = nil
        }
        guard let cmd = takeWord(from: &rest) else {
            throw IRCParseError.missingCommand
        }
        command = cmd
        
        while !rest.isEmpty {
            if rest.first == ":" {
                trailing = String(rest.dropFirst())
                break
            }
            if let param = takeWord(from: &rest) {
                params.append(param)
            }
        }
        
        self.prefix = prefix
        self.command = command
        self.params = params
        self.trailing = trailing
    }
}

enum IRCParseError: Error, Equatable {
    case emptyLine
    case missingCommand
}

private func takeWord(from rest: inout Substring) -> String? {
    guard !rest.isEmpty else {
        return nil
    }
    let word: Substring
    guard let space = rest.firstIndex(of: " ") else {
        word = rest
        rest = ""
        return String(word)
    }
    word = rest[..<space]
    let after = rest.index(after: space)
    rest = rest[after...]
    return String(word)
}
