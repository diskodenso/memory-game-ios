# Memory Game - iOS App

## Belegarbeit Mobile Betriebssysteme

Ein natives Memory-Spiel für iOS, entwickelt mit SwiftUI und MVVM-Architektur.

## Verwendete SF-Symbols

Die folgenden 10 SF-Symbols stehen im Pool zur Auswahl (4 werden pro Spiel zufällig gewählt):

| Symbol | SF-Symbol Name |
|--------|----------------|
| ⭐ | `star.fill` |
| ❤️ | `heart.fill` |
| 🌙 | `moon.fill` |
| ☀️ | `sun.max.fill` |
| ⚡ | `bolt.fill` |
| 🍃 | `leaf.fill` |
| 🔥 | `flame.fill` |
| 💧 | `drop.fill` |
| ☁️ | `cloud.fill` |
| ❄️ | `snowflake` |

## Projektstruktur (MVVM)

```
MemoryGame/
├── MemoryGameApp.swift          # App Entry Point
├── Models/
│   ├── Card.swift               # Karten-Datenmodell
│   └── GameRecord.swift         # Highscore-Modell
├── ViewModels/
│   └── MemoryGameViewModel.swift # Spiellogik & State
├── Views/
│   ├── ContentView.swift        # Hauptansicht (2x4 Grid)
│   ├── CardView.swift           # Karten-View mit Flip-Animation
│   ├── TimerView.swift          # Timer-Anzeige
│   └── HighscoreView.swift      # Highscore-Liste
└── Services/
    └── PersistenceManager.swift # Datenspeicherung
```

## Persistenz-Logik

Die Persistenz-Logik befindet sich in:

**`Services/PersistenceManager.swift`**

### Speichermethode
- **FileManager** mit **JSON-Encoding**
- Speicherort: `Documents/highscores.json`
- Alle Spielergebnisse werden persistent gespeichert (nicht nur der Highscore)

### Gespeicherte Daten pro Spiel
- `id`: Eindeutige ID (UUID)
- `timeInSeconds`: Benötigte Zeit (TimeInterval)
- `date`: Datum und Uhrzeit des Spielendes (Date)

## Technische Details

- **Sprache**: Swift 5
- **Framework**: SwiftUI
- **iOS Version**: iOS 16+
- **Zielgerät**: iPhone (Portrait Mode)
- **Architektur**: MVVM

## Features

### Pflichtfeatures (Belegaufgabe)
- ✅ 2x4 Grid-Layout mit dynamischer Anpassung
- ✅ 3D Flip-Animation für Karten
- ✅ Timer startet bei erstem Kartentipp
- ✅ Automatische Match-Erkennung
- ✅ Gewinn-Alert mit Zeitanzeige
- ✅ Persistente Highscore-Speicherung (alle Ergebnisse)
- ✅ Dark Mode Unterstützung

### Bonus-Features
- ✅ **Highscore-Ansicht**: Vollständige Liste aller gespeicherten Ergebnisse mit Rankings
- ✅ **App-Lifecycle-Handling**: Timer pausiert automatisch im Hintergrund ("Race to Sleep")
- ✅ **Trophy-Icons**: Visualisierung der Top 3 Plätze in der Highscore-Liste
- ✅ **Responsive Design**: Optimiert für iPhone 17 Pro

## Bedienung

1. **Spiel starten**: Tippe auf eine beliebige Karte - der Timer startet automatisch
2. **Highscores ansehen**: Tippe auf das 🏆-Icon oben rechts
3. **Neues Spiel**: Nutze den "Neues Spiel" Button nach Spielende oder während des Spiels

