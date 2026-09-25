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

@Test func mapsTaggedPrivmsg() throws {
    let now = Date()
    let irc = try IRCMessage(parsing: "@badge-info=;badges=turbo/1;color=#0D4200;display-name=Ronni;emotes=25:0-4,12-16/1902:6-10;id=b34ccfc7-4977-403a-8a94-33c6bac34fb8;mod=0;room-id=1337;subscriber=0;tmi-sent-ts=1507246572675;turbo=1;user-id=1337;user-type=global_mod :ronni!ronni@ronni.tmi.twitch.tv PRIVMSG #ronni :Kappa Keepo Kappa")
    let message = try #require(ChatMessage(irc: irc, receivedAt: now))
    
    #expect(message.id == "b34ccfc7-4977-403a-8a94-33c6bac34fb8")
    #expect(message.timestamp == Date(timeIntervalSince1970: 1_507_246_572.675))
    #expect(message.author?.login == "ronni")
    #expect(message.author?.displayName == "Ronni")
    #expect(message.author?.userID == "1337")
    #expect(message.author?.color == RGB(r: 13, g: 66, b: 0))
}

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
