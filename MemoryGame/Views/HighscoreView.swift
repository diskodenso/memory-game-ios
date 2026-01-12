//
//  HighscoreView.swift
//  MemoryGame
//
//  Ansicht zur Darstellung aller gespeicherten Highscores
//

import SwiftUI

/// View zur Anzeige aller gespeicherten Spielergebnisse
struct HighscoreView: View {
    
    /// Zugriff auf das aktuelle Farbschema
    @Environment(\.colorScheme) private var colorScheme
    
    /// Dismiss-Action zum Schließen der View
    @Environment(\.dismiss) private var dismiss
    
    /// Alle gespeicherten Highscores
    @State private var highscores: [GameRecord] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrund
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if highscores.isEmpty {
                        // Leerzustand
                        VStack(spacing: 12) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("Noch keine Highscores")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Spiele dein erstes Spiel!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    } else {
                        // Liste der Highscores
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(Array(highscores.enumerated()), id: \.element.id) { index, record in
                                    HighscoreRow(
                                        rank: index + 1,
                                        record: record,
                                        isBest: index == 0
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("🏆 Highscores")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(accentColor)
                }
            }
        }
        .onAppear {
            loadHighscores()
        }
    }
    
    /// Lädt die Highscores aus der Persistenz
    private func loadHighscores() {
        highscores = PersistenceManager.shared.loadAllRecords()
    }
    
    // MARK: - Color Properties
    
    /// Hintergrundfarbe
    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.1, green: 0.1, blue: 0.15)
            : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    /// Akzentfarbe
    private var accentColor: Color {
        Color(red: 0.3, green: 0.5, blue: 0.8)
    }
}

/// Einzelne Highscore-Zeile
struct HighscoreRow: View {
    
    let rank: Int
    let record: GameRecord
    let isBest: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 16) {
            // Rang
            Text("\(rank).")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(rankColor)
                .frame(width: 40, alignment: .leading)
            
            // Trophy für Platz 1-3
            if rank <= 3 {
                Image(systemName: trophyIcon)
                    .font(.system(size: 24))
                    .foregroundColor(trophyColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Zeit
                Text(record.formattedTime)
                    .font(.system(size: 22, weight: .semibold, design: .monospaced))
                    .foregroundColor(textColor)
                
                // Datum
                Text(record.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.1), radius: isBest ? 8 : 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isBest ? accentColor : Color.clear, lineWidth: 2)
        )
    }
    
    // MARK: - Computed Properties
    
    private var trophyIcon: String {
        switch rank {
        case 1: return "trophy.fill"
        case 2: return "medal.fill"
        case 3: return "medal.fill"
        default: return ""
        }
    }
    
    private var trophyColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75)
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return .gray
        }
    }
    
    private var rankColor: Color {
        isBest ? accentColor : .secondary
    }
    
    private var textColor: Color {
        colorScheme == .dark ? .white : Color(red: 0.2, green: 0.2, blue: 0.3)
    }
    
    private var cardBackground: Color {
        colorScheme == .dark
            ? Color(red: 0.15, green: 0.15, blue: 0.2)
            : .white
    }
    
    private var accentColor: Color {
        Color(red: 0.3, green: 0.5, blue: 0.8)
    }
}

// MARK: - Preview

#Preview {
    HighscoreView()
}
