import SwiftUI
import AppKit

struct ContentView: View {
    @State private var selectedFontName = "Helvetica"
    @State private var numberFontSize: CGFloat = 72
    @State private var unitFontSize: CGFloat = 36
    @State private var value: Double = 56
    @State private var opacity: Double = 1.0
    @State private var scale: Double = 1.0
    @State private var systemFonts: [String] = []
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                // First speedometer (inner ring with color)
                InnerColoredSpeedometer(
                    value: value,
                    selectedFontName: selectedFontName,
                    numberFontSize: numberFontSize,
                    unitFontSize: unitFontSize,
                    opacity: opacity,
                    scale: scale
                )
                
                // Second speedometer (outer ring with color)
                OuterColoredSpeedometer(
                    value: value,
                    selectedFontName: selectedFontName,
                    numberFontSize: numberFontSize,
                    unitFontSize: unitFontSize,
                    opacity: opacity,
                    scale: scale
                )
                
                // Third speedometer (non-closed inner arc)
                NonClosedInnerSpeedometer(
                    value: value,
                    selectedFontName: selectedFontName,
                    numberFontSize: numberFontSize,
                    unitFontSize: unitFontSize,
                    opacity: opacity,
                    scale: scale
                )
            }
            .padding(.vertical, 20)
            
            // Controls area
            VStack(spacing: 16) {
                // Font selection
                HStack {
                    Text("字体:")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Picker("选择字体", selection: $selectedFontName) {
                        ForEach(systemFonts, id: \.self) { fontName in
                            Text(fontName)
                                .font(.custom(fontName, size: 14))
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 200)
                }
                
                // Value slider
                HStack {
                    Text("数值: \(Int(value))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Slider(value: $value, in: 0...120, step: 1)
                        .frame(width: 200)
                }
                
                // Opacity slider
                HStack {
                    Text("透明度: \(String(format: "%.1f", opacity))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Slider(value: $opacity, in: 0.1...1.0, step: 0.1)
                        .frame(width: 200)
                }
                
                // Scale slider
                HStack {
                    Text("缩放比例: \(String(format: "%.1f", scale))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Slider(value: $scale, in: 0.5...2.0, step: 0.1)
                        .frame(width: 200)
                }
                
                // Font size sliders
                VStack(spacing: 12) {
                    HStack {
                        Text("数值字体大小: \(Int(numberFontSize))")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Slider(value: $numberFontSize, in: 24...120, step: 1)
                            .frame(width: 200)
                    }
                    
                    HStack {
                        Text("单位字体大小: \(Int(unitFontSize))")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Slider(value: $unitFontSize, in: 12...60, step: 1)
                            .frame(width: 200)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .background(Color.black)
        .onAppear {
            loadSystemFonts()
        }
    }
    
    private func loadSystemFonts() {
        let fontManager = NSFontManager.shared
        systemFonts = fontManager.availableFontFamilies.sorted()
    }
}