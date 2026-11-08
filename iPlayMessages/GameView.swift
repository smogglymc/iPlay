import SwiftUI

struct GameView: View {
    let incoming: GameSession?
    let localPlayer: String
    let remotePlayer: String
    let onSend: (GameSession) -> Void

    @State private var category = "All"
    @State private var selected: GameDefinition?
    @State private var session: GameSession?
    @State private var move = ""
    @State private var error = ""

    init(incoming: GameSession?, localPlayer: String, remotePlayer: String, onSend: @escaping (GameSession) -> Void) {
        self.incoming = incoming
        self.localPlayer = localPlayer
        self.remotePlayer = remotePlayer
        self.onSend = onSend
        _session = State(initialValue: incoming)
        _selected = State(initialValue: incoming.flatMap { GameCatalog.game($0.gameID) })
    }

    private let categories = ["All","Brain","Quick","Creative","Strategy","Party"]

    var body: some View {
        NavigationStack {
            if let game = selected, let current = session {
                gameScreen(game, current)
            } else {
                gamePicker
            }
        }
        .tint(.purple)
    }

    private var gamePicker: some View {
        VStack(spacing: 8) {
            VStack(spacing: 2) {
                Text("iPlay").font(.system(size: 30, weight: .black, design: .rounded))
                Text("Your chats. Your games. Your friends.").font(.caption).foregroundStyle(.secondary)
            }.padding(.top, 8)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) { item in
                        Button(item) { category = item }
                            .buttonStyle(.borderedProminent)
                            .tint(category == item ? .purple : .gray.opacity(0.25))
                    }
                }.padding(.horizontal)
            }
            List(filtered) { game in
                Button {
                    guard let conversationGame = GameCatalog.game(game.id) else { return }
                    let created = GameSession.create(game: conversationGame, playerOne: localPlayer, playerTwo: remotePlayer)
                    selected = game
                    session = created
                    move = ""
                    error = ""
                    onSend(created)
                } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Text(game.title).font(.headline)
                            Spacer()
                            Text(game.category.uppercased()).font(.system(size: 9, weight: .bold)).foregroundStyle(.purple)
                        }
                        Text(game.prompt).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                    }.padding(.vertical, 3)
                }.foregroundStyle(.primary)
            }
        }.navigationTitle("Choose a game")
    }

    private var filtered: [GameDefinition] {
        category == "All" ? GameCatalog.all : GameCatalog.all.filter { $0.category == category }
    }

    @ViewBuilder
    private func gameScreen(_ game: GameDefinition, _ current: GameSession) -> some View {
        VStack(spacing: 12) {
            Text(game.title).font(.title2.bold())
            HStack {
                score("You", current.playerOne == localPlayer ? current.scoreOne : current.scoreTwo)
                score("Friend", current.playerOne == localPlayer ? current.scoreTwo : current.scoreOne)
            }
            Text(current.prompt).font(.headline).multilineTextAlignment(.center)
                .frame(maxWidth: .infinity).padding(12)
                .background(.purple.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 14))

            if game.mode == .tictactoe {
                tictactoeBoard(current)
            } else if !current.choices.isEmpty {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(current.choices, id: \.self) { choice in
                        Button(choice) { move = choice }
                            .buttonStyle(.bordered)
                            .tint(move == choice ? .purple : .gray)
                    }
                }
            } else {
                TextField(placeholder(for: game), text: $move, axis: .vertical)
                    .textFieldStyle(.roundedBorder).lineLimit(1...3)
                    .textInputAutocapitalization(.sentences)
            }

            if !error.isEmpty { Text(error).font(.caption).foregroundStyle(.red) }
            Text(current.status).font(.caption).foregroundStyle(.secondary).multilineTextAlignment(.center)

            if current.finished {
                Text("Game over").font(.headline).foregroundStyle(.purple)
                Button("Choose another game") { selected = nil; session = nil }
                    .buttonStyle(.borderedProminent)
            } else if current.currentPlayer != localPlayer {
                Label("Waiting for your friend", systemImage: "hourglass")
                    .font(.callout).foregroundStyle(.secondary)
            } else {
                Button("Send Turn") {
                    switch GameEngine.submit(move, session: current, player: localPlayer) {
                    case .invalid(let message): error = message
                    case .success(let updated, _):
                        error = ""; move = ""; session = updated; onSend(updated)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(move.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            Button("Back to games") { selected = nil; session = nil }.font(.caption)
            Spacer(minLength: 0)
        }.padding().navigationTitle("iPlay")
    }

    private func score(_ name: String, _ value: Int) -> some View {
        VStack {
            Text(name).font(.caption).foregroundStyle(.secondary)
            Text("\(value)").font(.title3.bold())
        }.frame(maxWidth: .infinity).padding(8).background(.quaternary).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func tictactoeBoard(_ current: GameSession) -> some View {
        VStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { col in
                        let index = row * 3 + col
                        Button(current.board[index].isEmpty ? " " : current.board[index]) {
                            move = String(index + 1)
                        }
                        .font(.title.bold()).frame(maxWidth: .infinity).frame(height: 48)
                        .background(move == String(index + 1) ? .purple.opacity(0.2) : .gray.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .disabled(!current.board[index].isEmpty)
                    }
                }
            }
        }
    }

    private func placeholder(for game: GameDefinition) -> String {
        switch game.mode {
        case .wordchain: return "Enter a word"
        case .guess: return "Guess 1–20"
        case .number: return "Enter a number"
        case .text: return "Write your answer or contribution"
        case .grid: return "Enter a coordinate or move"
        default: return "Your move"
        }
    }
}
