import Testing
@testable import TwitchIRC

@Test func noTagsGivesEmptyDictionary() throws {
    let m = try IRCMessage(parsing: "PING :tmi.twitch.tv")
    
    #expect(m.tags.isEmpty)
}

@Test func handlesInvalidEscapesAndEmptyKeys() throws {
    let m = try IRCMessage(parsing: #"@empty;bad=x\qy;tail=z\ :tmi.twitch.tv 001 nick :Welcome"#)
    
    #expect(m.tags["empty"] == "")
    #expect(m.tags["bad"] == "xqy")
    #expect(m.tags["tail"] == "z")
    #expect(m.command == "001")
}

@Test func unescapesTagValues() throws {
    let m1 = try IRCMessage(parsing: #"@badge-info=;badges=staff/1,broadcaster/1,turbo/1;color=#008000;display-name=ronni;emotes=;id=db25007f-7a18-43eb-9379-80131e44d633;login=ronni;mod=0;msg-id=resub;msg-param-cumulative-months=6;msg-param-streak-months=2;msg-param-should-share-streak=1;msg-param-sub-plan=Prime;msg-param-sub-plan-name=Prime;room-id=1337;subscriber=1;system-msg=ronni\shas\ssubscribed\sfor\s6\smonths!;tmi-sent-ts=1507246572675;turbo=1;user-id=1337;user-type=staff :tmi.twitch.tv USERNOTICE #dallas :Great stream -- keep it up!"#)
    
    #expect(m1.tags["system-msg"] == "ronni has subscribed for 6 months!")
    
    let m2 = try IRCMessage(parsing: #"@note=a\:b\\c\rd\ne;dash=x-y\sz :tmi.twitch.tv NOTICE #dallas :ok"#)
    
    #expect(m2.tags["note"] == "a;b\\c\rd\ne")
    #expect(m2.tags["dash"] == "x-y z")
}

@Test func parsesTags() throws {
    let m = try IRCMessage(parsing: "@badge-info=;badges=turbo/1;color=#0D4200;display-name=ronni;emotes=25:0-4,12-16/1902:6-10;id=b34ccfc7-4977-403a-8a94-33c6bac34fb8;mod=0;room-id=1337;subscriber=0;tmi-sent-ts=1507246572675;turbo=1;user-id=1337;user-type=global_mod :ronni!ronni@ronni.tmi.twitch.tv PRIVMSG #ronni :Kappa Keepo Kappa")
    
    #expect(m.tags.count == 13)
    #expect(m.tags["display-name"] == "ronni")
    #expect(m.tags["id"] == "b34ccfc7-4977-403a-8a94-33c6bac34fb8")
    #expect(m.tags["tmi-sent-ts"] == "1507246572675")
    #expect(m.tags["emotes"] == "25:0-4,12-16/1902:6-10")
    #expect(m.tags["badge-info"] == "")
    
    #expect(m.prefix == "ronni!ronni@ronni.tmi.twitch.tv")
    #expect(m.command == "PRIVMSG")
    #expect(m.params == ["#ronni"])
    #expect(m.trailing == "Kappa Keepo Kappa")
}

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
