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
    public let userID: String?
    public let color: RGB?
    
    public init(login: String, displayName: String, userID: String? = nil, color: RGB? = nil) {
        self.login = login
        self.displayName = displayName
        self.userID = userID
        self.color = color
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
