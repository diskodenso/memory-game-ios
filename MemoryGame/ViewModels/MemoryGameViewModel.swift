//
//  MemoryGameViewModel.swift
//  MemoryGame
//
//  ViewModel für die Spiellogik und State Management (MVVM)
//

import Foundation
import Combine

/// ViewModel für das Memory-Spiel
/// Verwaltet den Spielzustand, Timer und Spiellogik
class MemoryGameViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Die 8 Karten des Spiels (4 Paare)
    @Published var cards: [Card] = []
    
    /// Vergangene Zeit seit dem ersten Kartentipp in Sekunden
    @Published var elapsedTime: TimeInterval = 0
    
    /// Gibt an, ob das Spiel gewonnen wurde (alle Paare gefunden)
    @Published var isGameWon: Bool = false
    
    /// Gibt an, ob der Timer läuft
    @Published var isTimerRunning: Bool = false
    
    /// Gibt an, ob das Spiel pausiert wurde (durch Background/Inactive)
    @Published var isGamePaused: Bool = false
    
    // MARK: - Private Properties
    
    /// Pool an verfügbaren SF-Symbol-Namen
    private let symbolPool: [String] = [
        "star.fill",
        "heart.fill",
        "moon.fill",
        "sun.max.fill",
        "bolt.fill",
        "leaf.fill",
        "flame.fill",
        "drop.fill",
        "cloud.fill",
        "snowflake"
    ]
    
    /// Timer für die Zeitmessung
    private var timer: Timer?
    
    /// Index der ersten aufgedeckten Karte (für Match-Prüfung)
    private var firstFlippedCardIndex: Int?
    
    /// Gibt an, ob gerade auf Auto-Flip gewartet wird
    private var isProcessingMatch: Bool = false
    
    // MARK: - Initialization
    
    init() {
        resetGame()
    }
    
    // MARK: - Public Methods
    
    /// Setzt das Spiel zurück und mischt neue Karten
    func resetGame() {
        stopTimer()
        elapsedTime = 0
        isGameWon = false
        isTimerRunning = false
        isGamePaused = false
        firstFlippedCardIndex = nil
        isProcessingMatch = false
        
        // Wähle 4 zufällige Symbole aus dem Pool
        let selectedSymbols = Array(symbolPool.shuffled().prefix(4))
        
        // Erstelle Paare und mische sie
        var newCards: [Card] = []
        for symbol in selectedSymbols {
            newCards.append(Card(symbolName: symbol))
            newCards.append(Card(symbolName: symbol))
        }
        
        cards = newCards.shuffled()
    }
    
    /// Wird aufgerufen, wenn der User eine Karte antippt
    /// - Parameter card: Die angetippte Karte
    func chooseCard(_ card: Card) {
        // Finde den Index der Karte
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) else {
            return
        }
        
        // Ignoriere bereits gematchte oder aufgedeckte Karten
        guard !cards[chosenIndex].isMatched && !cards[chosenIndex].isFaceUp else {
            return
        }
        
        // Ignoriere Eingaben während der Match-Verarbeitung
        guard !isProcessingMatch else {
            return
        }
        
        // Starte Timer beim ersten Kartentipp
        if !isTimerRunning {
            startTimer()
        }
        
        // Decke die Karte auf
        cards[chosenIndex].isFaceUp = true
        
        if let firstIndex = firstFlippedCardIndex {
            // Zweite Karte aufgedeckt - prüfe auf Match
            checkForMatch(firstIndex: firstIndex, secondIndex: chosenIndex)
            firstFlippedCardIndex = nil
        } else {
            // Erste Karte aufgedeckt
            firstFlippedCardIndex = chosenIndex
        }
    }
    
    /// Pausiert das Spiel (Timer stoppen, Status merken)
    func pauseGame() {
        if isTimerRunning {
            stopTimer()
            isGamePaused = true
        }
    }
    
    /// Setzt das Spiel fort (Timer neu starten, wenn vorher pausiert)
    func resumeGame() {
        if isGamePaused && !isGameWon {
            startTimer()
            isGamePaused = false
        }
    }
    
    // MARK: - Private Methods
    
    /// Prüft, ob zwei aufgedeckte Karten ein Paar bilden
    private func checkForMatch(firstIndex: Int, secondIndex: Int) {
        let firstCard = cards[firstIndex]
        let secondCard = cards[secondIndex]
        
        if firstCard.symbolName == secondCard.symbolName {
            // Match gefunden!
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
            
            // Prüfe auf Spielende
            checkForGameWon()
        } else {
            // Kein Match - drehe Karten nach Verzögerung wieder um
            isProcessingMatch = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.cards[firstIndex].isFaceUp = false
                self.cards[secondIndex].isFaceUp = false
                self.isProcessingMatch = false
            }
        }
    }
    
    /// Prüft, ob alle Paare gefunden wurden
    private func checkForGameWon() {
        let allMatched = cards.allSatisfy { $0.isMatched }
        
        if allMatched {
            stopTimer()
            isGameWon = true
            
            // Speichere das Ergebnis
            let record = GameRecord(timeInSeconds: elapsedTime)
            PersistenceManager.shared.saveRecord(record)
        }
    }
    
    /// Startet den Timer
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.elapsedTime += 0.1
        }
    }
    
    /// Stoppt den Timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
}
