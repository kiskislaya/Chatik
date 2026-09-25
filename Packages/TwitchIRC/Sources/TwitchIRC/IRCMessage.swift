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
    let tags: [String: String]
    
    init(parsing line: String) throws {
        var rest = line[...]
        let prefix: String?
        let command: String
        var params: [String] = []
        var trailing: String?
        let tags: [String: String]
        
        guard !rest.isEmpty else {
            throw IRCParseError.emptyLine
        }
        
        if rest.first == "@" {
            rest = rest.dropFirst()
            guard let raw = takeWord(from: &rest) else {
                throw IRCParseError.missingCommand
            }
            tags = parseTags(raw)
        } else {
            tags = [:]
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
        self.tags = tags
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

private func parseTags(_ raw: String) -> [String: String] {
    let raws = raw.split(separator: ";")
    var result: [String: String] = [:]
    
    for r in raws {
        let pair = r.split(separator: "=", maxSplits: 1)
        if pair.count == 2 {
            result[String(pair[0])] = unescapeTagValue(pair[1])
        } else if pair.count == 1 {
            result[String(pair[0])] = ""
        }
    }
    
    return result
}

private func unescapeTagValue(_ raw: Substring) -> String {
    let scalars = raw.unicodeScalars
    guard scalars.contains(#"\"#) else {
        return String(raw)
    }
    
    var flag = false
    var out = String.UnicodeScalarView()
    for scalar in scalars {
        if flag {
            switch scalar {
            case ":":
                out.append(";")
            case "s":
                out.append(" ")
            case #"\"#:
                out.append(#"\"#)
            case "r":
                out.append("\r")
            case "n":
                out.append("\n")
            default:
                out.append(scalar)
            }
            flag = false
        } else if scalar == #"\"# {
            flag = true
        } else {
            out.append(scalar)
        }
    }
    
    return String(out)
}
