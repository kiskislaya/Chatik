//
//  IRCConnectionTests.swift
//  TwitchIRC
//
//  Created by Kseniya on 21.09.2026.
//

import Foundation
import ChatikCore
import Testing
@testable import TwitchIRC

@Test func deliversPrivmsgAndAnswersPing() async throws {
    let fake = FakeTransport(frames: ["PING :tmi.twitch.tv\r\n", ":kotik!kotik@kotik.tmi.twitch.tv PRIVMSG #xqc :hello world\r\n"])
    let connection = IRCConnection(transport: fake)
    let stream = try await connection.connect(nick: "justinfan1")
    try await connection.join("xqc")
    var received: [ChatMessage] = []
    for await message in stream {
        received.append(message)
    }
    #expect(received.count == 1)
    #expect(received.first?.text == "hello world")
    let sent = await fake.sent
    #expect(sent.contains("NICK justinfan1"))
    #expect(sent.contains("JOIN #xqc"))
    #expect(sent.contains("PONG :tmi.twitch.tv"))
}
