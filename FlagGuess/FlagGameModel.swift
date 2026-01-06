//
//  FlagGameModel.swift
//  FlagGuess
//
//  Created by FaNik on 2025-09-24.
//

import Foundation

struct LeaderboardEntry: Identifiable, Codable {
    let id = UUID()
    let score: Int
    let totalTime: TimeInterval
    let accuracy: Double
    let finalScore: Int
    let date: Date
}

class FlagGameModel: ObservableObject {
    @Published var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"
    ]
    @Published var correctAnswer = 0
    @Published var showingScore = false
    @Published var scoreTitle = ""
    @Published var score = 0
    @Published var questionCount = 0
    @Published var showingFinalAlert = false
    @Published var currentTime: TimeInterval = 0
    @Published var showingLeaderboard = false
    @Published var leaderboard: [LeaderboardEntry] = []

    private let maxQuestions = 8
    private var gameStartTime: Date?
    private var timer: Timer?
    private var gameStarted = false

    init() {
        loadLeaderboard()
        newGame()
    }

    func flagTapped(_ number: Int) {
        if !gameStarted {
            startTimer()
            gameStarted = true
        }

        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }

        showingScore = true
        questionCount += 1
    }

    func askQuestion() {
        if questionCount == maxQuestions {
            endGame()
            return
        }

        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func newGame() {
        questionCount = 0
        score = 0
        currentTime = 0
        gameStarted = false
        stopTimer()
        askQuestion()
    }

    private func startTimer() {
        gameStartTime = Date()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let startTime = self.gameStartTime {
                self.currentTime = Date().timeIntervalSince(startTime)
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func endGame() {
        stopTimer()

        let accuracy = Double(score) / Double(maxQuestions)
        let timeBonus = max(0, 100 - Int(currentTime))
        let finalScore = score * 10 + timeBonus

        let entry = LeaderboardEntry(
            score: score,
            totalTime: currentTime,
            accuracy: accuracy,
            finalScore: finalScore,
            date: Date()
        )

        leaderboard.append(entry)
        leaderboard.sort { $0.finalScore > $1.finalScore }
        leaderboard = Array(leaderboard.prefix(10))

        saveLeaderboard()
        showingFinalAlert = true
    }

    func showLeaderboard() {
        showingLeaderboard = true
    }

    private func saveLeaderboard() {
        if let encoded = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encoded, forKey: "leaderboard")
        }
    }

    private func loadLeaderboard() {
        if let data = UserDefaults.standard.data(forKey: "leaderboard"),
           let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            leaderboard = decoded
        }
    }
}