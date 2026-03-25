import SwiftUI

struct DoubleGradientSpeedometer: SpeedometerBase {
    let value: Double
    let selectedFontName: String
    let numberFontSize: CGFloat
    let unitFontSize: CGFloat
    let opacity: Double
    let scale: Double
    
    init(
        value: Double = 0,
        selectedFontName: String = "Helvetica",
        numberFontSize: CGFloat = 72,
        unitFontSize: CGFloat = 36,
        opacity: Double = 1.0,
        scale: Double = 1.0
    ) {
        self.value = value
        self.selectedFontName = selectedFontName
        self.numberFontSize = numberFontSize
        self.unitFontSize = unitFontSize
        self.opacity = opacity
        self.scale = scale
    }
    
    var body: some View {
        scaledAndOpaque(
            ZStack {
                // Outer gradient ring
                dynamicArcRing(diameter: 250)
                
                // Middle white ring
                baseCircleRing(diameter: 220)
                
                // Inner gradient ring (reversed direction)
                Circle()
                    .trim(from: 0, to: arcRatio(for: value))
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .fill(reversedGradientForValue(value))
                    .frame(width: 190, height: 190)
                    .rotationEffect(.degrees(270))
                
                // Numerical and unit display
                valueAndUnitDisplay()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
    
    // 反向渐变颜色
    private func reversedGradientForValue(_ value: Double) -> LinearGradient {
        let startColor: Color
        let endColor: Color
        
        switch value {
        case 0...30:
            startColor = .blue.opacity(0.5)
            endColor = .blue
        case 30...50:
            startColor = .yellow
            endColor = .green
        default:
            startColor = .red
            endColor = .orange
        }
        
        return LinearGradient(
            gradient: Gradient(colors: [startColor, endColor]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}