//
//  IRCConnection.swift
//  TwitchIRC
//
//  Created by Kseniya on 21.09.2026.
//

import Foundation
import ChatikCore

public actor IRCConnection {
    private let transport: any IRCTransport
    private var readLoop: Task<Void, Never>?
    private var continuation: AsyncStream<ChatMessage>.Continuation?
    
    public init(transport: any IRCTransport) {
        self.transport = transport
    }
    
    public func connect(nick: String) async throws -> AsyncStream<ChatMessage> {
        try await transport.connect()
        try await transport.send("NICK \(nick)")
        let (stream, continuation) = AsyncStream.makeStream(of: ChatMessage.self)
        self.continuation = continuation
        readLoop = Task{ await self.run() }
        return stream
    }
    
    public func join(_ channel: String) async throws {
        try await transport.send("JOIN #\(channel.lowercased())")
    }
    
    public func disconnect() async  {
        readLoop?.cancel()
        await transport.disconnect()
        continuation?.finish()
        readLoop = nil
        continuation = nil
    }
    
    public static func anonymousNick() -> String {
        return "justinfan" + String(Int.random(in: 10_000...99_999))
    }
    
    private func run() async {
        while !Task.isCancelled {
            do {
                let frame = try await transport.receive()
                await handle(frame)
            } catch {
                break
            }
        }
        continuation?.finish()
    }
    
    private func handle(_ frame: String) async {
        for line in frame.split(separator: "\r\n") {
            do {
                let irc = try IRCMessage(parsing: String(line))
                if irc.command == "PING" {
                    try? await transport.send("PONG :\(irc.trailing ?? "tmi.twitch.tv")")
                }
                if let message = ChatMessage(irc: irc, receivedAt: Date()) {
                    continuation?.yield(message)
                }
            } catch {
                continue
            }
        }
    }
}
