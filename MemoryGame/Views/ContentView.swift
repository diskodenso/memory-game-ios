//
//  ContentView.swift
//  MemoryGame
//
//  Hauptansicht des Memory-Spiels mit 2x4 Grid
//

import SwiftUI

/// Hauptansicht des Memory-Spiels
struct ContentView: View {
    
    /// Das ViewModel, das den Spielzustand verwaltet
    @StateObject private var viewModel = MemoryGameViewModel()
    
    /// Zugriff auf den aktuellen Szenen-Status (Active, Inactive, Background)
    @Environment(\.scenePhase) private var scenePhase
    
    /// Zugriff auf das aktuelle Farbschema
    @Environment(\.colorScheme) private var colorScheme
    
    /// Steuerung der Highscore-Ansicht
    @State private var showHighscores = false
    
    /// Grid-Layout mit 2 Spalten
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            // Hintergrund
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                // Header mit Titel und Highscore-Button
                HStack {
                    Spacer()
                    
                    Text("Memory")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(titleColor)
                    
                    Spacer()
                    
                    Button(action: {
                        showHighscores = true
                    }) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 22))
                            .foregroundColor(buttonColor)
                    }
                    .padding(.trailing, 12)
                }
                
                // Timer
                TimerView(
                    elapsedTime: viewModel.elapsedTime,
                    isRunning: viewModel.isTimerRunning
                )
                
                // Spielanleitung (nur vor Spielstart)
                if !viewModel.isTimerRunning && viewModel.elapsedTime == 0 {
                    Text("Tippe auf eine Karte, um zu beginnen")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .transition(.opacity)
                }
                
                // Karten-Grid (2x4)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .frame(maxHeight: 140)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    viewModel.chooseCard(card)
                                }
                            }
                    }
                }
                .padding(.horizontal, 16)
                
                // Neues Spiel Button
                Button(action: {
                    withAnimation {
                        viewModel.resetGame()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Neues Spiel")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(buttonColor)
                    )
                }
            }
            .padding(.top, 80)
            .padding(.bottom, 60)
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
        // Gewinn-Alert
        .alert("Glückwunsch! 🎉", isPresented: $viewModel.isGameWon) {
            Button("Neues Spiel") {
                withAnimation {
                    viewModel.resetGame()
                }
            }
            Button("Spiel beenden", role: .destructive) {
                exit(0)
            }
        } message: {
            Text("Du hast \(Int(viewModel.elapsedTime)) Sekunden benötigt.")
        }
        // Highscore-Sheet
        .sheet(isPresented: $showHighscores) {
            HighscoreView()
        }
        // Lifecycle-Handling
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .inactive, .background:
                viewModel.pauseGame()
            case .active:
                viewModel.resumeGame()
            @unknown default:
                break
            }
        }
    }
    
    // MARK: - Color Properties
    
    /// Hintergrundfarbe der App
    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.1, green: 0.1, blue: 0.15)
            : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    /// Titelfarbe
    private var titleColor: Color {
        colorScheme == .dark
            ? Color.white
            : Color(red: 0.2, green: 0.2, blue: 0.3)
    }
    
    /// Button-Farbe
    private var buttonColor: Color {
        colorScheme == .dark
            ? Color(red: 0.3, green: 0.5, blue: 0.8)
            : Color(red: 0.3, green: 0.5, blue: 0.8)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
