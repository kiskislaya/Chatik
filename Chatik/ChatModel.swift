//
//  ChatModel.swift
//  Chatik
//
//  Created by Kseniya on 21.09.2026.
//

import Foundation
import ChatikCore
import TwitchIRC

@MainActor
@Observable
final class ChatModel {
    private(set) var messages: [ChatMessage] = []
    private var pending: [ChatMessage] = []
    private var connection: IRCConnection?
    private var readTask: Task<Void, Never>?
    private var flushTask: Task<Void, Never>?
    private let limit = 1000
    
    func connect(to channel: String) {
        disconnect()
        let connection = IRCConnection(transport: WebSocketTransport(url: WebSocketTransport.twitchURL))
        self.connection = connection
        readTask = Task {
            do {
                let stream = try await connection.connect(nick: IRCConnection.anonymousNick())
                try await connection.join(channel)
                for await message in stream {
                    pending.append(message)
                }
            } catch {
                print("error: ", error)
            }
        }
        
        flushTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(100))
                flush()
            }
        }
    }
    
    func disconnect() {
        readTask?.cancel()
        flushTask?.cancel()
        Task {
            await connection?.disconnect()
        }
        connection = nil
        readTask = nil
        flushTask = nil
    }
    
    private func flush() {
        if pending.isEmpty {
            
        } else {
            messages.append(contentsOf: pending)
            pending.removeAll()
        }
        if messages.count > limit {
            messages.removeFirst(messages.count - limit)
        }
    }
}
