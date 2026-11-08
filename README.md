# iPlay — iOS Messages Game Project

This folder contains the source for an iOS host app and an Apple Messages extension.

## Project contents

- `iPlay/` — the small host iOS app that installs the Messages extension.
- `iPlayMessages/` — the SwiftUI interface, game catalog, session model, and Messages extension controller.
- `project.yml` — XcodeGen project definition.
- 50 game entries across Brain, Quick, Creative, Strategy, and Party categories.

## Current implementation status

This is a source project, not a compiled or signed IPA. It has not yet been built with Xcode or tested on two iPhones.

The game catalog contains 50 titles. The current engine provides starter turn-based mechanics for choice, text, word-chain, number, higher/lower, Rock Paper Scissors, number guessing, Tic-Tac-Toe, and simple grid turns. Several catalog entries still share generic mechanics. Games such as Connect Four, Fleet Finder, Dots & Boxes, and Checkers Mini need dedicated board logic before they can be described as complete versions of those games.

The Rock Paper Scissors state handling has been corrected so the first player's move is preserved until the second player submits a move. The catalog's accidentally escaped line breaks have also been converted to real Swift source line breaks.

## Important limitations

- The source has not been compiled. A successful build must be verified with Xcode on macOS.
- A Messages extension is bundled inside a normal iOS app. The host app is required for installation, while gameplay can take place inside Messages.
- Every participant needs to install iPlay themselves. iOS does not let a message silently install an app.
- Session data is currently encoded into the message URL. This is a prototype transport, not a secure server-backed multiplayer system. Do not use it for prizes, payments, or competitive rankings.
- The URL host in `MessagesViewController.swift` is a reserved placeholder (`iplay.invalid`). It is not a public website or universal link.

## Build requirements

You need a Mac with Xcode to generate the Xcode project, compile the app and extension, sign them, and create an installable IPA. Windows can be used to edit the Swift files, but Windows alone cannot run Apple's Xcode toolchain.

On a Mac:

1. Install and open Xcode.
2. Install XcodeGen (for example, with Homebrew: `brew install xcodegen`).
3. Open Terminal and change directory to the folder containing `project.yml`.
4. Run `xcodegen generate`.
5. Open `iPlay.xcodeproj` in Xcode.
6. In Signing & Capabilities, select your Apple development team and use a bundle identifier you control.
7. Build and test the host app and Messages extension on an iPhone.
8. Install iPlay on both test devices and test complete back-and-forth turns in Messages.

A free Apple ID may be sufficient for personal development testing with restrictions; App Store distribution requires the appropriate Apple Developer Program membership and App Store review.
