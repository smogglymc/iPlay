import Foundation

enum GameMode: String, Codable {
    case choice, text, memory, yesno, wordchain, number, higherlower, tictactoe, grid, rps, guess
}

struct GameDefinition: Identifiable, Codable {
    let id: String
    let title: String
    let category: String
    let mode: GameMode
    let prompt: String
    let choices: [String]
    let answer: String
}

enum GameCatalog {
    static let all: [GameDefinition] = [
        GameDefinition(id: "trivia-sprint", title: "Trivia Sprint", category: "Brain", mode: .choice, prompt: "Which planet is called the Red Planet?", choices: ["Venus", "Mars", "Jupiter", "Mercury"], answer: "Mars"),
        GameDefinition(id: "word-scramble", title: "Word Scramble", category: "Brain", mode: .text, prompt: "Unscramble this word: RTAES", choices: [], answer: "STARE"),
        GameDefinition(id: "riddle-duel", title: "Riddle Duel", category: "Brain", mode: .text, prompt: "What has keys but cannot open locks?", choices: [], answer: "PIANO"),
        GameDefinition(id: "memory-match", title: "Memory Match", category: "Brain", mode: .memory, prompt: "Find the matching pair: 🍎 🍌 🍇 🍎", choices: ["🍎", "🍌", "🍇", "🍐"], answer: "🍎"),
        GameDefinition(id: "twenty-questions", title: "Twenty Questions", category: "Brain", mode: .yesno, prompt: "I'm thinking of an animal: it can fly. Is it a bird?", choices: ["Yes", "No"], answer: "Yes"),
        GameDefinition(id: "math-dash", title: "Math Dash", category: "Brain", mode: .choice, prompt: "What is 17 + 28?", choices: ["43", "44", "45", "46"], answer: "45"),
        GameDefinition(id: "emoji-decode", title: "Emoji Decode", category: "Brain", mode: .choice, prompt: "Decode this: ⭐ + 🐟", choices: ["Goldfish", "Starfish", "Seahorse", "Clownfish"], answer: "Starfish"),
        GameDefinition(id: "odd-one-out", title: "Odd One Out", category: "Brain", mode: .choice, prompt: "Which one is not a fruit?", choices: ["Apple", "Banana", "Carrot", "Grape"], answer: "Carrot"),
        GameDefinition(id: "word-chain", title: "Word Chain", category: "Brain", mode: .wordchain, prompt: "Start with any word. The next word must begin with its last letter.", choices: [], answer: ""),
        GameDefinition(id: "flag-finder", title: "Flag Finder", category: "Brain", mode: .choice, prompt: "Which country has a maple leaf on its flag?", choices: ["Canada", "Japan", "Brazil", "Greece"], answer: "Canada"),
        GameDefinition(id: "reaction-test", title: "Reaction Test", category: "Quick", mode: .choice, prompt: "Reaction round: tap the symbol that is different.", choices: ["🔵", "🔵", "🟠", "🔵"], answer: "🟠"),
        GameDefinition(id: "tap-race", title: "Tap Race", category: "Quick", mode: .number, prompt: "Tap race: enter a number from 1 to 10. Closest to 7 scores.", choices: [], answer: "7"),
        GameDefinition(id: "fast-fingers", title: "Fast Fingers", category: "Quick", mode: .text, prompt: "Type this sequence exactly: P L A Y", choices: [], answer: "PLAY"),
        GameDefinition(id: "higher-or-lower", title: "Higher or Lower", category: "Quick", mode: .higherlower, prompt: "The current number is 5. Will the next number be higher or lower?", choices: ["Higher", "Lower"], answer: ""),
        GameDefinition(id: "color-rush", title: "Color Rush", category: "Quick", mode: .choice, prompt: "Select the color named here: BLUE", choices: ["🔴 Red", "🔵 Blue", "🟢 Green", "🟡 Yellow"], answer: "🔵 Blue"),
        GameDefinition(id: "quick-draw", title: "Quick Draw", category: "Quick", mode: .choice, prompt: "Quick draw! Pick the fastest animal.", choices: ["Sloth", "Cheetah", "Turtle", "Snail"], answer: "Cheetah"),
        GameDefinition(id: "number-rush", title: "Number Rush", category: "Quick", mode: .choice, prompt: "Find the largest number.", choices: ["18", "81", "28", "71"], answer: "81"),
        GameDefinition(id: "pattern-tap", title: "Pattern Tap", category: "Quick", mode: .text, prompt: "Continue the pattern: 2, 4, 6, 8, __", choices: [], answer: "10"),
        GameDefinition(id: "speed-sort", title: "Speed Sort", category: "Quick", mode: .choice, prompt: "Which group contains only even numbers?", choices: ["1, 2, 3", "2, 4, 8", "3, 5, 7", "1, 4, 9"], answer: "2, 4, 8"),
        GameDefinition(id: "reflex-duel", title: "Reflex Duel", category: "Quick", mode: .choice, prompt: "Avoid the decoy. Which symbol is a star?", choices: ["◆", "●", "★", "▲"], answer: "★"),
        GameDefinition(id: "draw-guess", title: "Draw & Guess", category: "Creative", mode: .text, prompt: "Describe a simple drawing of a house using words; your friend guesses the object.", choices: [], answer: "HOUSE"),
        GameDefinition(id: "caption-battle", title: "Caption Battle", category: "Creative", mode: .text, prompt: "Write a funny caption for: a penguin wearing sunglasses.", choices: [], answer: ""),
        GameDefinition(id: "story-builder", title: "Story Builder", category: "Creative", mode: .text, prompt: "Add one sentence to this story: 'The tiny robot opened the mysterious door...'", choices: [], answer: ""),
        GameDefinition(id: "emoji-story", title: "Emoji Story", category: "Creative", mode: .text, prompt: "Tell a tiny story using at least 3 emoji.", choices: [], answer: ""),
        GameDefinition(id: "pixel-picture", title: "Pixel Picture", category: "Creative", mode: .choice, prompt: "Pixel clue: 🟨🟨🟨 / ⬛🟨⬛ / 🟨🟨🟨. What simple shape is shown?", choices: ["Circle", "Square", "Triangle", "Star"], answer: "Square"),
        GameDefinition(id: "doodle-duel", title: "Doodle Duel", category: "Creative", mode: .text, prompt: "Describe your doodle for the prompt: a friendly alien.", choices: [], answer: ""),
        GameDefinition(id: "finish-sentence", title: "Finish the Sentence", category: "Creative", mode: .text, prompt: "Finish this sentence creatively: 'If my backpack could talk, it would...'", choices: [], answer: ""),
        GameDefinition(id: "logo-guess", title: "Logo Guess", category: "Creative", mode: .choice, prompt: "Which company is known for a bitten apple logo?", choices: ["Apple", "Microsoft", "Nintendo", "Adobe"], answer: "Apple"),
        GameDefinition(id: "mystery-picture", title: "Mystery Picture", category: "Creative", mode: .choice, prompt: "Clue: I have a trunk, big ears, and live on land. What am I?", choices: ["Elephant", "Giraffe", "Rhino", "Hippo"], answer: "Elephant"),
        GameDefinition(id: "name-that-sound", title: "Name That Sound", category: "Creative", mode: .choice, prompt: "Which sound does a clock usually make?", choices: ["Moo", "Tick-tock", "Woof", "Buzz"], answer: "Tick-tock"),
        GameDefinition(id: "tic-tac-toe", title: "Tic-Tac-Toe", category: "Strategy", mode: .tictactoe, prompt: "Choose a square on the 3×3 board.", choices: ["1", "2", "3", "4", "5", "6", "7", "8", "9"], answer: ""),
        GameDefinition(id: "connect-four", title: "Connect Four", category: "Strategy", mode: .grid, prompt: "Choose a column from 1 to 4.", choices: ["1", "2", "3", "4"], answer: ""),
        GameDefinition(id: "fleet-finder", title: "Fleet Finder", category: "Strategy", mode: .grid, prompt: "Secret grid: choose a coordinate A1–D4.", choices: ["A1", "B1", "C1", "D1", "A2", "B2", "C2", "D2"], answer: ""),
        GameDefinition(id: "rock-paper-scissors", title: "Rock Paper Scissors", category: "Strategy", mode: .rps, prompt: "Choose your move. Your choice is revealed after both players move.", choices: ["Rock", "Paper", "Scissors"], answer: ""),
        GameDefinition(id: "dots-boxes", title: "Dots & Boxes", category: "Strategy", mode: .text, prompt: "Claim an edge using a coordinate such as A1-B1.", choices: [], answer: ""),
        GameDefinition(id: "checkers-mini", title: "Checkers Mini", category: "Strategy", mode: .text, prompt: "Enter a simple move using notation like B6-C5.", choices: [], answer: ""),
        GameDefinition(id: "four-corners", title: "Four Corners", category: "Strategy", mode: .choice, prompt: "Pick a corner to claim.", choices: ["Top left", "Top right", "Bottom left", "Bottom right"], answer: ""),
        GameDefinition(id: "nim", title: "Nim", category: "Strategy", mode: .choice, prompt: "There are 7 tokens. How many do you take? (1, 2, or 3)", choices: ["1", "2", "3"], answer: ""),
        GameDefinition(id: "territory-takeover", title: "Territory Takeover", category: "Strategy", mode: .choice, prompt: "Choose a territory to claim.", choices: ["North", "South", "East", "West"], answer: ""),
        GameDefinition(id: "number-battle", title: "Number Battle", category: "Strategy", mode: .number, prompt: "Choose a number card from 1 to 10.", choices: [], answer: ""),
        GameDefinition(id: "would-you-rather", title: "Would You Rather", category: "Party", mode: .choice, prompt: "Would you rather explore space or the deep ocean?", choices: ["Space", "Deep ocean"], answer: ""),
        GameDefinition(id: "this-or-that", title: "This or That", category: "Party", mode: .choice, prompt: "Pick one: sunrise or sunset?", choices: ["Sunrise", "Sunset"], answer: ""),
        GameDefinition(id: "two-truths", title: "Two Truths", category: "Party", mode: .choice, prompt: "Which statement is false?", choices: ["Octopuses have three hearts", "A day on Venus is longer than its year", "Bats are blind", "Honey can last a very long time"], answer: "Bats are blind"),
        GameDefinition(id: "clean-never-have-i-ever", title: "Clean Never Have I Ever", category: "Party", mode: .choice, prompt: "Have you ever built a blanket fort?", choices: ["Yes", "No", "Not yet"], answer: ""),
        GameDefinition(id: "guess-my-number", title: "Guess My Number", category: "Party", mode: .guess, prompt: "Guess the secret number from 1 to 20.", choices: [], answer: ""),
        GameDefinition(id: "secret-word", title: "Secret Word", category: "Party", mode: .text, prompt: "Describe a sunny day without using the words sun, bright, or warm.", choices: [], answer: ""),
        GameDefinition(id: "categories", title: "Categories", category: "Party", mode: .text, prompt: "Name an animal beginning with the letter B.", choices: [], answer: ""),
        GameDefinition(id: "who-knows-who", title: "Who Knows Who?", category: "Party", mode: .choice, prompt: "Which snack would your friend choose?", choices: ["Popcorn", "Pretzels", "Fruit", "Cookies"], answer: ""),
        GameDefinition(id: "daily-challenge", title: "Daily Challenge", category: "Party", mode: .choice, prompt: "Daily challenge: which is a primary color?", choices: ["Purple", "Green", "Red", "Orange"], answer: "Red"),
        GameDefinition(id: "mystery-challenge", title: "Mystery Challenge", category: "Party", mode: .choice, prompt: "Mystery challenge: which shape has exactly 3 sides?", choices: ["Square", "Triangle", "Pentagon", "Circle"], answer: "Triangle"),
    ]

    static func game(_ id: String) -> GameDefinition? { all.first { $0.id == id } }
}
