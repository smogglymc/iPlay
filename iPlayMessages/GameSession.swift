import Foundation

struct GameSession: Codable {
    var version: Int = 1
    var gameID: String
    var sessionID: String
    var playerOne: String
    var playerTwo: String
    var currentPlayer: String
    var moveNumber: Int = 0
    var scoreOne: Int = 0
    var scoreTwo: Int = 0
    var prompt: String
    var choices: [String]
    var answer: String
    var lastMove: String = ""
    var firstMove: String = ""
    var firstMovePlayer: String = ""
    var board: [String] = Array(repeating: "", count: 9)
    var usedWords: [String] = []
    var currentNumber: Int = 5
    var secretNumber: Int = Int.random(in: 1...20)
    var attemptsLeft: Int = 5
    var status: String = "Your challenge is ready."
    var finished: Bool = false
    var winner: String = ""

    var isPlayerOneTurn: Bool { currentPlayer == playerOne }

    func encoded() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    static func decode(_ string: String) -> GameSession? {
        var base64 = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let remainder = base64.count % 4
        if remainder > 0 {
            base64 += String(repeating: "=", count: 4 - remainder)
        }
        guard let data = Data(base64Encoded: base64) else { return nil }
        return try? JSONDecoder().decode(GameSession.self, from: data)
    }

    static func create(game: GameDefinition, playerOne: String, playerTwo: String) -> GameSession {
        GameSession(
            gameID: game.id,
            sessionID: UUID().uuidString,
            playerOne: playerOne,
            playerTwo: playerTwo,
            currentPlayer: playerTwo,
            prompt: game.prompt,
            choices: game.choices,
            answer: game.answer
        )
    }
}

enum MoveOutcome {
    case success(GameSession, String)
    case invalid(String)
}

enum GameEngine {
    static func submit(_ raw: String, session original: GameSession, player: String) -> MoveOutcome {
        guard !original.finished else { return .invalid("This game has ended.") }
        guard original.currentPlayer == player else { return .invalid("It is the other player's turn.") }

        let move = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !move.isEmpty else { return .invalid("Choose or enter a move first.") }

        guard let game = GameCatalog.game(original.gameID) else {
            return .invalid("Unknown game.")
        }

        var s = original
        let isPlayerOne = player == s.playerOne
        let otherPlayer = isPlayerOne ? s.playerTwo : s.playerOne
        let playerNumber = isPlayerOne ? "Player 1" : "Player 2"

        func addPoint() {
            if isPlayerOne { s.scoreOne += 1 } else { s.scoreTwo += 1 }
        }

        func finish(_ message: String, winner: String = "") -> MoveOutcome {
            s.finished = true
            s.status = message
            s.winner = winner
            return .success(s, message)
        }

        func next(_ message: String) -> MoveOutcome {
            s.currentPlayer = otherPlayer
            s.status = message
            return .success(s, message)
        }

        switch game.mode {
        case .choice, .memory, .yesno:
            s.moveNumber += 1
            if !game.answer.isEmpty {
                let correct = move.caseInsensitiveCompare(game.answer) == .orderedSame
                if correct { addPoint() }

                if s.moveNumber >= 6 {
                    let result: String
                    let winner: String
                    if s.scoreOne == s.scoreTwo {
                        result = "It's a tie!"
                        winner = ""
                    } else if s.scoreOne > s.scoreTwo {
                        result = "Player 1 wins!"
                        winner = s.playerOne
                    } else {
                        result = "Player 2 wins!"
                        winner = s.playerTwo
                    }
                    return finish("\(result) Final score: \(s.scoreOne)–\(s.scoreTwo).", winner: winner)
                }
                return next(correct ? "Correct answer! Next turn." : "Not quite. Next turn.")
            }

            s.usedWords.append(move)
            if s.moveNumber >= 6 {
                return finish("Both players have finished their turns.")
            }
            return next("Answer recorded. Next player's turn.")

        case .text:
            s.moveNumber += 1
            s.usedWords.append(move)
            if s.moveNumber >= 6 {
                return finish("Challenge complete! Both players contributed.")
            }
            return next("Move saved. Pass it back!")

        case .wordchain:
            let word = move.lowercased().filter { $0.isLetter }
            guard word.count >= 2 else { return .invalid("Use a word with at least two letters.") }
            guard !s.usedWords.contains(word) else { return .invalid("That word was already used.") }
            if let previous = s.usedWords.last, word.first != previous.last {
                return .invalid("Your word must start with \(previous.last!).")
            }
            s.usedWords.append(word)
            s.moveNumber += 1
            if s.usedWords.count >= 10 {
                return finish("Word chain complete! \(s.usedWords.count) words played.")
            }
            return next("Good word! Next word starts with \(word.last!).")

        case .number:
            guard let number = Int(move), (1...10).contains(number) else {
                return .invalid("Enter a whole number from 1 to 10.")
            }
            s.moveNumber += 1
            if number == 7 { addPoint() }
            if s.moveNumber >= 6 {
                return finish("Number race finished. Score: \(s.scoreOne)–\(s.scoreTwo).")
            }
            return next(number == 7 ? "Bullseye!" : "Number saved. Next turn.")

        case .higherlower:
            let choice = move.lowercased()
            guard ["higher", "lower"].contains(choice) else {
                return .invalid("Choose Higher or Lower.")
            }
            let nextNumber = Int.random(in: 1...10)
            let correct = (choice == "higher" && nextNumber > s.currentNumber)
                || (choice == "lower" && nextNumber < s.currentNumber)
            if correct { addPoint() }
            s.currentNumber = nextNumber
            s.moveNumber += 1
            if s.moveNumber >= 6 {
                return finish("Higher or Lower finished. Score: \(s.scoreOne)–\(s.scoreTwo).")
            }
            s.prompt = "The number is \(nextNumber). Will the next number be Higher or Lower?"
            return next(correct ? "Correct prediction!" : "Not this time.")

        case .rps:
            let choice = move.lowercased()
            guard ["rock", "paper", "scissors"].contains(choice) else {
                return .invalid("Choose Rock, Paper, or Scissors.")
            }

            s.moveNumber += 1
            if s.firstMove.isEmpty {
                s.firstMove = choice
                s.firstMovePlayer = player
                return next("Choice locked. Waiting for the other player.")
            }

            let firstChoice = s.firstMove
            let firstPlayer = s.firstMovePlayer
            let firstWins = (firstChoice == "rock" && choice == "scissors")
                || (firstChoice == "paper" && choice == "rock")
                || (firstChoice == "scissors" && choice == "paper")

            if firstChoice != choice {
                let firstPlayerWon = firstWins
                let winnerID = firstPlayerWon ? firstPlayer : player
                if winnerID == s.playerOne {
                    s.scoreOne += 1
                } else {
                    s.scoreTwo += 1
                }
            }

            s.firstMove = ""
            s.firstMovePlayer = ""
            if s.moveNumber >= 10 {
                let result = s.scoreOne == s.scoreTwo
                    ? "Rock Paper Scissors ended in a tie."
                    : (s.scoreOne > s.scoreTwo ? "Player 1 wins!" : "Player 2 wins!")
                return finish("\(result) Score: \(s.scoreOne)–\(s.scoreTwo).",
                              winner: s.scoreOne == s.scoreTwo ? "" : (s.scoreOne > s.scoreTwo ? s.playerOne : s.playerTwo))
            }
            return next(firstChoice == choice ? "Tie round!" : "Round complete!")

        case .guess:
            guard let guess = Int(move), (1...20).contains(guess) else {
                return .invalid("Enter a number from 1 to 20.")
            }
            s.attemptsLeft -= 1
            s.moveNumber += 1
            if guess == s.secretNumber {
                addPoint()
                return finish("You guessed it! The number was \(s.secretNumber).", winner: player)
            }
            if s.attemptsLeft <= 0 {
                return finish("No guesses left. The number was \(s.secretNumber).")
            }
            return next(guess < s.secretNumber
                        ? "Too low. \(s.attemptsLeft) guesses remain."
                        : "Too high. \(s.attemptsLeft) guesses remain.")

        case .tictactoe:
            guard let index = Int(move), (1...9).contains(index) else {
                return .invalid("Choose a square from 1 to 9.")
            }
            let boardIndex = index - 1
            guard s.board[boardIndex].isEmpty else {
                return .invalid("That square is taken.")
            }
            s.board[boardIndex] = isPlayerOne ? "X" : "O"
            s.moveNumber += 1
            if hasWon(s.board, isPlayerOne ? "X" : "O") {
                return finish("\(playerNumber) wins!", winner: player)
            }
            if s.board.allSatisfy({ !$0.isEmpty }) {
                return finish("It's a draw!")
            }
            return next("Move played.")

        case .grid:
            s.usedWords.append(move)
            s.moveNumber += 1
            if s.moveNumber >= 8 {
                return finish("Grid challenge complete!")
            }
            return next("Move saved.")
        }
    }

    private static func hasWon(_ board: [String], _ mark: String) -> Bool {
        let lines = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        return lines.contains { line in line.allSatisfy { board[$0] == mark } }
    }
}
