//
//  CardView.swift
//  MemoryGame
//
//  View für eine einzelne Memory-Karte mit Flip-Animation
//

import SwiftUI

/// View für eine einzelne Memory-Karte
/// Zeigt entweder die Rückseite oder das SF-Symbol mit 3D Flip-Animation
struct CardView: View {
    
    /// Die Kartendaten
    let card: Card
    
    /// Zugriff auf das aktuelle Farbschema (Light/Dark Mode)
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Rückseite der Karte
                RoundedRectangle(cornerRadius: 12)
                    .fill(cardBackColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(cardBorderColor, lineWidth: 2)
                    )
                    .overlay(
                        // Muster auf der Rückseite
                        Image(systemName: "questionmark")
                            .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.4))
                            .foregroundColor(cardBackPatternColor)
                    )
                    .opacity(card.isFaceUp ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(card.isFaceUp ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                
                // Vorderseite der Karte
                RoundedRectangle(cornerRadius: 12)
                    .fill(cardFrontColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(cardBorderColor, lineWidth: 2)
                    )
                    .overlay(
                        Image(systemName: card.symbolName)
                            .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.5))
                            .foregroundColor(symbolColor)
                    )
                    .opacity(card.isFaceUp ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(card.isFaceUp ? 0 : -180),
                        axis: (x: 0, y: 1, z: 0)
                    )
            }
            .opacity(card.isMatched ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 0.4), value: card.isFaceUp)
            .animation(.easeInOut(duration: 0.3), value: card.isMatched)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    // MARK: - Color Properties
    
    /// Hintergrundfarbe der Kartenrückseite
    private var cardBackColor: Color {
        colorScheme == .dark
            ? Color(red: 0.2, green: 0.3, blue: 0.5)
            : Color(red: 0.3, green: 0.5, blue: 0.8)
    }
    
    /// Musterfarbe auf der Rückseite
    private var cardBackPatternColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.3)
            : Color.white.opacity(0.5)
    }
    
    /// Hintergrundfarbe der Kartenvorderseite
    private var cardFrontColor: Color {
        colorScheme == .dark
            ? Color(red: 0.15, green: 0.15, blue: 0.2)
            : Color.white
    }
    
    /// Randfarbe der Karte
    private var cardBorderColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.3)
            : Color.gray.opacity(0.3)
    }
    
    /// Farbe des SF-Symbols
    private var symbolColor: Color {
        colorScheme == .dark
            ? Color(red: 0.4, green: 0.7, blue: 1.0)
            : Color(red: 0.3, green: 0.5, blue: 0.8)
    }
}

// MARK: - Preview

#Preview {
    HStack {
        CardView(card: Card(symbolName: "star.fill"))
            .frame(width: 100, height: 100)
        
        CardView(card: Card(id: UUID(), symbolName: "heart.fill"))
            .frame(width: 100, height: 100)
    }
    .padding()
}
