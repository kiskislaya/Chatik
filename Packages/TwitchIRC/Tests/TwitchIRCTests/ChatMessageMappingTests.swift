//
//  ChatMessageMappingTests.swift
//  TwitchIRC
//
//  Created by Kseniya on 21.09.2026.
//

import Foundation
import ChatikCore
import Testing
@testable import TwitchIRC

@Test func mapsPrivmsg() throws {
    let now = Date()
    let irc = try IRCMessage(parsing: ":kotik!kotik@kotik.tmi.twitch.tv PRIVMSG #xqc :hello world")
    let message = try #require(ChatMessage(irc: irc, receivedAt: now))
    #expect(!message.id.isEmpty)
    #expect(message.channel == "xqc")
    #expect(message.timestamp == now)
    #expect(message.author?.login == "kotik")
    #expect(message.author?.displayName == "kotik")
    #expect(message.text == "hello world")
}

@Test func ignoresNonPrivmsg() throws {
    let now = Date()
    let ircPing = try IRCMessage(parsing: "PING :tmi.twitch.tv")
    let ircJoin = try IRCMessage(parsing: ":justinfan12345!justinfan12345@justinfan12345.tmi.twitch.tv JOIN #xqc")
    let messagePing = ChatMessage(irc: ircPing, receivedAt: now)
    let messageJoin = ChatMessage(irc: ircJoin, receivedAt: now)
    #expect(messagePing == nil)
    #expect(messageJoin == nil)
}
