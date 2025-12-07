//
//  ContentView.swift
//  FlagGuess
//
//  Created by FaNik on 2025-09-22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameModel: FlagGameModel

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    Text("Flag Guess")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        gameModel.showLeaderboard()
                    }) {
                        Image(systemName: "trophy.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                    }
                }

                HStack {
                    Text("Time: \(String(format: "%.1f", gameModel.currentTime))s")
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()

                    Text("Question \(gameModel.questionCount + 1)/8")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(gameModel.countries[gameModel.correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            gameModel.flagTapped(number)
                        } label: {
                            FlagImage(imageName: gameModel.countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(gameModel.score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(gameModel.scoreTitle, isPresented: $gameModel.showingScore) {
            Button("Continue", action: gameModel.askQuestion)
        } message: {
            Text("Your score is \(gameModel.score)")
        }
        .alert("Game Over", isPresented: $gameModel.showingFinalAlert) {
            Button("Start Again", action: gameModel.newGame)
            Button("Leaderboard", action: gameModel.showLeaderboard)
        } message: {
            let accuracy = Double(gameModel.score) / 8.0 * 100
            let timeBonus = max(0, 100 - Int(gameModel.currentTime))
            let finalScore = gameModel.score * 10 + timeBonus
            Text("Score: \(gameModel.score)/8 (\(String(format: "%.0f", accuracy))%)\nTime: \(String(format: "%.1f", gameModel.currentTime))s\nFinal Score: \(finalScore)")
        }
        .sheet(isPresented: $gameModel.showingLeaderboard) {
            LeaderboardView()
                .environmentObject(gameModel)
        }
    }
}



struct FlagImage: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 200, height: 120)
            .clipShape(.rect(cornerRadius: 8))
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
        .environmentObject(FlagGameModel())
}
