import Testing
import Foundation
import ChatikCore

@Test func rejectsBadHex() {
    let empty = RGB(hex: "")
    let tooLong = RGB(hex: "#GGGGGGGG")
    let wrongStart = RGB(hex: "Z#000000")
    let tooShort = RGB(hex: "#12345")
    let wrongHEX = RGB(hex: "#GGGGGG")

    #expect(empty == nil)
    #expect(tooLong == nil)
    #expect(wrongStart == nil)
    #expect(tooShort == nil)
    #expect(wrongHEX == nil)
}

@Test func parsesHexColor() {
    let withGrid = RGB(hex: "#0D4200")
    let noGrid = RGB(hex: "0D4200")
    
    #expect(withGrid?.r == 13)
    #expect(withGrid?.g == 66)
    #expect(withGrid?.b == 0)
    #expect(noGrid?.r == 13)
    #expect(noGrid?.g == 66)
    #expect(noGrid?.b == 0)
}

@Test func createAuthorAndChatMessage() {
    let author = Author(login: "login", displayName: "name")
    let now = Date()
    let chatMessage = ChatMessage(
        id: "id",
        channel: "channel",
        timestamp: now,
        author: author,
        text:  "text"
    )
    #expect(author.login == "login")
    #expect(author.displayName == "name")
    #expect(chatMessage.text == "text")
    #expect(chatMessage.author?.login == "login")
    #expect(chatMessage.author?.displayName == "name")
    #expect(chatMessage.channel == "channel")
    #expect(chatMessage.timestamp == now)
    #expect(chatMessage.id == "id")
}
