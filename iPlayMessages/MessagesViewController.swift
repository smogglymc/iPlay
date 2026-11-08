import Messages
import SwiftUI

final class MessagesViewController: MSMessagesAppViewController {
    private var host: UIHostingController<GameView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        showPicker()
    }

    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        guard let message = conversation.selectedMessage,
              let url = message.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let payload = components.queryItems?.first(where: { $0.name == "s" })?.value,
              let state = GameSession.decode(payload) else {
            showPicker()
            return
        }
        show(state)
    }

    private var localID: String {
        activeConversation?.localParticipantIdentifier.uuidString ?? "local-player"
    }

    private var remoteID: String {
        activeConversation?.remoteParticipantIdentifiers.first?.uuidString ?? "remote-player"
    }

    private func showPicker() {
        let root = GameView(incoming: nil, localPlayer: localID, remotePlayer: remoteID) { [weak self] in self?.send($0) }
        install(UIHostingController(rootView: root))
    }

    private func show(_ state: GameSession) {
        let root = GameView(incoming: state, localPlayer: localID, remotePlayer: remoteID) { [weak self] in self?.send($0) }
        install(UIHostingController(rootView: root))
    }

    private func install(_ controller: UIHostingController<GameView>) {
        if let old = host {
            old.willMove(toParent: nil); old.view.removeFromSuperview(); old.removeFromParent()
        }
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        controller.didMove(toParent: self)
        host = controller
    }

    private func send(_ state: GameSession) {
        guard let conversation = activeConversation,
              let payload = state.encoded(),
              var components = URLComponents(string: "https://iplay.invalid/session") else { return }
        components.queryItems = [URLQueryItem(name: "s", value: payload)]
        let layout = MSMessageTemplateLayout()
        layout.caption = "🎮 iPlay · \(GameCatalog.game(state.gameID)?.title ?? "Game")"
        layout.subcaption = state.status
        layout.trailingCaption = state.finished ? "Finished" : "Play turn"
        let message = MSMessage()
        message.url = components.url
        message.layout = layout
        conversation.insert(message) { error in
            if let error { print("iPlay message insertion error: \(error.localizedDescription)") }
        }
    }
}
