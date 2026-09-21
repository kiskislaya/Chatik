//
//  FakeTransport.swift
//  TwitchIRC
//
//  Created by Kseniya on 21.09.2026.
//

@testable import TwitchIRC

actor FakeTransport: IRCTransport {
    var frames: [String]
    var sent: [String] = []
    
    func receive() async throws -> String {
        guard !frames.isEmpty else {
            throw FakeTransportError.closed
        }
        return frames.removeFirst()
    }
    
    func send(_ line: String) async throws {
        sent.append(line)
    }
    
    func connect() async throws {
        
    }
    
    func disconnect() async {
        
    }
    
    init(frames: [String]) {
        self.frames = frames
    }
}

enum FakeTransportError: Error {
    case closed
}
