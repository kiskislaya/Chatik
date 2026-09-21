import Testing
@testable import TwitchIRC

@Test func parsesPing() throws {
    let m = try IRCMessage(parsing: "PING :tmi.twitch.tv")
    
    #expect(m.prefix == nil)
    #expect(m.command == "PING")
    #expect(m.params == [])
    #expect(m.trailing == "tmi.twitch.tv")
}

@Test func parsesWelcome() throws {
    let m = try IRCMessage(parsing: ":tmi.twitch.tv 001 justinfan12345 :Welcome, GLHF!")
    
    #expect(m.prefix == "tmi.twitch.tv")
    #expect(m.command == "001")
    #expect(m.params == ["justinfan12345"])
    #expect(m.trailing == "Welcome, GLHF!")
}

@Test func parsesJoin() throws {
    let m = try IRCMessage(parsing: ":justinfan12345!justinfan12345@justinfan12345.tmi.twitch.tv JOIN #xqc")
    
    #expect(m.prefix == "justinfan12345!justinfan12345@justinfan12345.tmi.twitch.tv")
    #expect(m.command == "JOIN")
    #expect(m.params == ["#xqc"])
    #expect(m.trailing == nil)
}

@Test func parsesPrivmsg() throws {
    let m = try IRCMessage(parsing: ":kotik!kotik@kotik.tmi.twitch.tv PRIVMSG #xqc :hello world")
    
    #expect(m.prefix == "kotik!kotik@kotik.tmi.twitch.tv")
    #expect(m.command == "PRIVMSG")
    #expect(m.params == ["#xqc"])
    #expect(m.trailing == "hello world")
}

@Test func keepsColonsInTrailing() throws {
    let m = try IRCMessage(parsing: ":kotik!kotik@kotik.tmi.twitch.tv PRIVMSG #xqc :a: b :c")
    
    #expect(m.prefix == "kotik!kotik@kotik.tmi.twitch.tv")
    #expect(m.command == "PRIVMSG")
    #expect(m.params == ["#xqc"])
    #expect(m.trailing == "a: b :c")
}

@Test func rejectsEmptyLine() {
    #expect(throws: IRCParseError.emptyLine) { try IRCMessage(parsing: "") }
}
