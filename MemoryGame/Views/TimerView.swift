//
//  TimerView.swift
//  MemoryGame
//
//  View für die Timer-Anzeige im Format mm:ss
//

import SwiftUI

/// View für die Anzeige der vergangenen Spielzeit
struct TimerView: View {
    
    /// Die vergangene Zeit in Sekunden
    let elapsedTime: TimeInterval
    
    /// Gibt an, ob der Timer läuft (für visuelle Hervorhebung)
    let isRunning: Bool
    
    /// Zugriff auf das aktuelle Farbschema
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "timer")
                .font(.title2)
                .foregroundColor(timerIconColor)
            
            Text(formattedTime)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .foregroundColor(timerTextColor)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .shadow(color: shadowColor, radius: 4, x: 0, y: 2)
        )
    }
    
    // MARK: - Computed Properties
    
    /// Formatierte Zeitanzeige (mm:ss)
    private var formattedTime: String {
        let totalSeconds = Int(elapsedTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Farbe des Timer-Icons
    private var timerIconColor: Color {
        isRunning
            ? (colorScheme == .dark ? Color.green : Color.green)
            : (colorScheme == .dark ? Color.gray : Color.gray)
    }
    
    /// Farbe des Timer-Texts
    private var timerTextColor: Color {
        colorScheme == .dark ? Color.white : Color.primary
    }
    
    /// Hintergrundfarbe
    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.15, green: 0.15, blue: 0.2)
            : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    /// Schattenfarbe
    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.3)
            : Color.gray.opacity(0.2)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        TimerView(elapsedTime: 0, isRunning: false)
        TimerView(elapsedTime: 65, isRunning: true)
        TimerView(elapsedTime: 125.5, isRunning: true)
    }
    .padding()
}
