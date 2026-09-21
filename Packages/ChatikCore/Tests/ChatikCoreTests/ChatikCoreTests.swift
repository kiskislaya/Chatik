import Testing
import Foundation
import ChatikCore

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
