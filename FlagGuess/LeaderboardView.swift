//
//  LeaderboardView.swift
//  FlagGuess
//
//  Created by FaNik on 2025-10-12.
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var gameModel: FlagGameModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Leaderboard")
                    .font(.largeTitle.weight(.bold))

                // نمونه‌ی ساده برای نمایش امتیازها
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Score:")
                            .font(.headline)
                        Spacer()
                        Text("\(gameModel.score)/8")
                            .font(.headline)
                    }

                    HStack {
                        Text("Time:")
                            .font(.subheadline)
                        Spacer()
                        Text("\(String(format: "%.1f", gameModel.currentTime))s")
                            .font(.subheadline)
                    }

                    Divider()

                    // اگر می‌خوای لیست رکوردهای بیشتر داشته باشی،
                    // اینجا می‌تونی از یک آرایه ذخیره‌شده (UserDefaults یا CoreData) استفاده کنی.
                    Text("Top scores and stats will appear here.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Spacer()

                HStack {
                    Button("Reset Game") {
                        gameModel.newGame()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Close") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        // برای پیش‌نمایش باید یک نمونه از مدل رو تزریق کنیم
        LeaderboardView()
            .environmentObject(FlagGameModel())
    }
}

