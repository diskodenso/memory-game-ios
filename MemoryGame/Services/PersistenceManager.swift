//
//  PersistenceManager.swift
//  MemoryGame
//
//  Verantwortlich für die persistente Speicherung aller Highscores
//

import Foundation

/// Singleton-Klasse für die Datenpersistenz der Spielergebnisse
/// Speichert und lädt alle Highscores mittels FileManager und JSON-Encoding
class PersistenceManager {
    
    /// Shared Instance für globalen Zugriff
    static let shared = PersistenceManager()
    
    /// Privater Initializer für Singleton-Pattern
    private init() {}
    
    /// URL zur Highscore-Datei im Documents-Verzeichnis
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        return documentsDirectory.appendingPathComponent("highscores.json")
    }
    
    /// Speichert ein neues Spielergebnis
    /// - Parameter record: Das zu speichernde Spielergebnis
    func saveRecord(_ record: GameRecord) {
        var records = loadAllRecords()
        records.append(record)
        
        // Sortiere nach Zeit (aufsteigend = beste zuerst)
        records.sort { $0.timeInSeconds < $1.timeInSeconds }
        
        saveRecords(records)
    }
    
    /// Lädt alle gespeicherten Spielergebnisse
    /// - Returns: Array aller GameRecords, sortiert nach Zeit
    func loadAllRecords() -> [GameRecord] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let records = try decoder.decode([GameRecord].self, from: data)
            return records
        } catch {
            print("Fehler beim Laden der Highscores: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Speichert alle Spielergebnisse in die Datei
    /// - Parameter records: Array der zu speichernden GameRecords
    private func saveRecords(_ records: [GameRecord]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(records)
            try data.write(to: fileURL)
        } catch {
            print("Fehler beim Speichern der Highscores: \(error.localizedDescription)")
        }
    }
    
    /// Löscht alle gespeicherten Highscores (für Testzwecke)
    func clearAllRecords() {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Fehler beim Löschen der Highscores: \(error.localizedDescription)")
            }
        }
    }
}
