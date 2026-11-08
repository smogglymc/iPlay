import SwiftUI

@main
struct iPlayApp: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 12) {
                Text("iPlay").font(.system(size: 42, weight: .black, design: .rounded))
                Text("Your chats. Your games. Your friends.")
                    .foregroundStyle(.secondary)
                Text("Open Messages, tap the + button, and choose iPlay to play.")
                    .multilineTextAlignment(.center).padding()
            }
            .padding()
        }
    }
}
