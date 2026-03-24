import SwiftUI
import AppKit

struct ContentView: View {
    @State private var selectedFontName = "Helvetica"
    @State private var numberFontSize: CGFloat = 72
    @State private var unitFontSize: CGFloat = 36
    @State private var systemFonts: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            // Numerical display area
            VStack(spacing: 8) {
                Text("56")
                    .font(.custom(selectedFontName, size: numberFontSize))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("km/h")
                    .font(.custom(selectedFontName, size: unitFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Controls area
            VStack(spacing: 16) {
                // Font selection
                HStack {
                    Text("字体:")
                        .font(.headline)
                    
                    Picker("选择字体", selection: $selectedFontName) {
                        ForEach(systemFonts, id: \.self) { fontName in
                            Text(fontName)
                                .font(.custom(fontName, size: 14))
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 200)
                }
                
                // Font size sliders
                VStack(spacing: 12) {
                    HStack {
                        Text("数值字体大小: \(Int(numberFontSize))")
                            .font(.subheadline)
                        
                        Slider(value: $numberFontSize, in: 24...120, step: 1)
                            .frame(width: 200)
                    }
                    
                    HStack {
                        Text("单位字体大小: \(Int(unitFontSize))")
                            .font(.subheadline)
                        
                        Slider(value: $unitFontSize, in: 12...60, step: 1)
                            .frame(width: 200)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            loadSystemFonts()
        }
    }
    
    private func loadSystemFonts() {
        let fontManager = NSFontManager.shared
        systemFonts = fontManager.availableFontFamilies.sorted()
    }
}