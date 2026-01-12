//
//  Card.swift
//  MemoryGame
//
//  Datenmodell für eine Memory-Karte
//

import Foundation

/// Repräsentiert eine einzelne Karte im Memory-Spiel
struct Card: Identifiable, Equatable {
    /// Eindeutige ID der Karte
    let id: UUID
    
    /// Name des SF-Symbols für die Kartenvorderseite
    let symbolName: String
    
    /// Gibt an, ob die Karte aufgedeckt ist (Symbol sichtbar)
    var isFaceUp: Bool = false
    
    /// Gibt an, ob die Karte bereits gematcht wurde
    var isMatched: Bool = false
    
    /// Erstellt eine neue Karte mit einem zufälligen UUID
    /// - Parameter symbolName: Der Name des SF-Symbols
    init(symbolName: String) {
        self.id = UUID()
        self.symbolName = symbolName
    }
    
    /// Erstellt eine neue Karte mit einer spezifischen ID
    /// - Parameters:
    ///   - id: Die eindeutige ID der Karte
    ///   - symbolName: Der Name des SF-Symbols
    init(id: UUID, symbolName: String) {
        self.id = id
        self.symbolName = symbolName
    }
}
