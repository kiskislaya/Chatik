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
    @State private var model = ChatModel()
    @State private var channel = "ironmouse"
    
    var body: some View {
        VStack {
            HStack {
                TextField("Channel", text: $channel)
                Button("Sign in") {
                    model.connect(to: channel)
                }
            }
            List(model.messages) { message in
                HStack(alignment: .top) {
                    Text(message.author?.displayName ?? "").bold()
                    Text(message.text)
                }
            }
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
}
