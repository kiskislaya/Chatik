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
    }
}

#Preview {
    ContentView()
}
