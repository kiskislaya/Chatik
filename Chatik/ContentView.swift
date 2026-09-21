//
//  ContentView.swift
//  Chatik
//
//  Created by Kseniya on 19.09.2026.
//

import SwiftUI
import ChatikCore
import TwitchIRC

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            let connection = IRCConnection(transport: WebSocketTransport(url: WebSocketTransport.twitchURL))
            do {
                let stream = try await connection.connect(nick: IRCConnection.anonymousNick())
                try await connection.join("ironmouse")
                for await message in stream {
                    print(message.author?.login ?? "?", message.text)
                }
            } catch {
                print("error: ", error)
            }
        }
    }
}

#Preview {
    ContentView()
}
