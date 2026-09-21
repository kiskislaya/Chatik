//
//  ChatMessage.swift
//  ChatikCore
//
//  Created by Kseniya on 20.09.2026.
//
import Foundation

public struct Author: Sendable, Hashable {
    public let login: String
    public let displayName: String
    
    public init(login: String, displayName: String) {
        self.login = login
        self.displayName = displayName
    }
}

public struct ChatMessage: Sendable, Identifiable, Equatable {
    public let id: String
    public let channel: String
    public let timestamp: Date
    public let author: Author?
    public let text: String
    
    public init(id: String, channel: String, timestamp: Date, author: Author?, text: String) {
        self.id = id
        self.channel = channel
        self.timestamp = timestamp
        self.author = author
        self.text = text
    }
}
