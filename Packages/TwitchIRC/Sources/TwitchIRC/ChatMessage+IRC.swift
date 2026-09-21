//
//  ChatMessage+IRC.swift
//  TwitchIRC
//
//  Created by Kseniya on 21.09.2026.
//

import Foundation
import ChatikCore


extension ChatMessage {
    init?(irc message: IRCMessage, receivedAt: Date) {
        guard message.command == "PRIVMSG" else { return nil }
        guard let raw = message.params.first else { return nil }
        let channel = raw.hasPrefix("#") ? String(raw.dropFirst()) : raw
        guard let prefix = message.prefix else { return nil }
        let login = String(prefix.prefix(while: { $0 != "!" }))
        guard !login.isEmpty else { return nil }
        guard let text = message.trailing else { return nil }
        
        self.init(
            id: UUID().uuidString,
            channel: channel,
            timestamp: receivedAt,
            author: Author(login: login, displayName: login),
            text: text
            )
    }
}
