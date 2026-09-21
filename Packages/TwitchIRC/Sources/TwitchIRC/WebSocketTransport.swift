//
//  WebSocketTransport.swift
//  TwitchIRC
//
//  Created by Kseniya on 21.09.2026.
//

import Foundation

public actor WebSocketTransport: IRCTransport {
    private let url: URL
    private var task: URLSessionWebSocketTask?
    
    public static let twitchURL = URL(string: "wss://irc-ws.chat.twitch.tv:443")!
    
    public init(url: URL) {
        self.url = url
    }
    
    public func connect() async throws {
        let task = URLSession.shared.webSocketTask(with: url)
        task.resume()
        self.task = task
    }
    
    public func send(_ line: String) async throws {
        guard let task else { throw WebSocketTransportError.notConnected }
        try await task.send(.string(line + "\r\n"))
    }
    
    public func receive() async throws -> String {
        guard let task else { throw WebSocketTransportError.notConnected }
        switch try await task.receive() {
        case .string(let text):
            return text
        case .data(let data):
            return String(decoding: data, as: UTF8.self)
        @unknown default:
            return ""
        }
    }
    
    public func disconnect() async {
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
    }
    
}

enum WebSocketTransportError: Error {
    case notConnected
}
