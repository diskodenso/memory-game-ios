//
//  GameRecord.swift
//  MemoryGame
//
//  Datenmodell für gespeicherte Spielergebnisse (Highscores)
//

import Foundation

/// Repräsentiert ein gespeichertes Spielergebnis
struct GameRecord: Codable, Identifiable {
    /// Eindeutige ID des Spielergebnisses
    let id: UUID
    
    /// Benötigte Zeit in Sekunden
    let timeInSeconds: TimeInterval
    
    /// Datum und Uhrzeit des Spielendes
    let date: Date
    
    /// Erstellt ein neues Spielergebnis
    /// - Parameters:
    ///   - timeInSeconds: Die benötigte Zeit in Sekunden
    ///   - date: Das Datum des Spiels (Standard: aktuelles Datum)
    init(timeInSeconds: TimeInterval, date: Date = Date()) {
        self.id = UUID()
        self.timeInSeconds = timeInSeconds
        self.date = date
    }
    
    /// Formatierte Zeitanzeige (mm:ss)
    var formattedTime: String {
        let minutes = Int(timeInSeconds) / 60
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Formatiertes Datum
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: date)
    }
}
