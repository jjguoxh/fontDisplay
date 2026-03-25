import SwiftUI

struct ClassicDialSpeedometer: SpeedometerBase {
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
                // Outer dial with markings
                dialMarkings(diameter: 250)
                
                // Progress arc (solid color based on value)
                progressArc(diameter: 230)
                
                // Pointer
                pointer(diameter: 200)
                
                // Numerical and unit display
                valueAndUnitDisplay()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
    
    // 刻度标记
    private func dialMarkings(diameter: CGFloat) -> some View {
        ZStack {
            // Main circle
            baseCircleRing(diameter: diameter)
            
            // Major ticks (every 20 km/h)
            ForEach(0..<7, id: \.self) { index in
                let angle = Double(index) * 30.0 - 90.0
                let tickValue = Double(index) * 20.0
                
                VStack(spacing: 4) {
                    // Tick mark
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 3, height: 12)
                    
                    // Value label
                    Text("\(Int(tickValue))")
                        .font(.custom(selectedFontName, size: 12))
                        .foregroundColor(.white)
                }
                .offset(y: -diameter/2 + 25)
                .rotationEffect(.degrees(angle))
            }
            
            // Minor ticks (every 10 km/h)
            ForEach(0..<13, id: \.self) { index in
                let angle = Double(index) * 30.0 - 90.0
                
                Rectangle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 2, height: 8)
                    .offset(y: -diameter/2 + 25)
                    .rotationEffect(.degrees(angle))
            }
        }
    }
    
    // 进度圆弧
    private func progressArc(diameter: CGFloat) -> some View {
        Circle()
            .trim(from: 0, to: arcRatio(for: value))
            .stroke(solidColorForValue(value), lineWidth: 8)
            .frame(width: diameter, height: diameter)
            .rotationEffect(.degrees(-90))
    }
    
    // 纯色基于值
    private func solidColorForValue(_ value: Double) -> Color {
        switch value {
        case 0...30: return .blue
        case 30...50: return .yellow
        default: return .red
        }
    }
    
    // 指针
    private func pointer(diameter: CGFloat) -> some View {
        let pointerAngle = (value / 120.0) * 270.0 - 135.0
        
        return ZStack {
            // Pointer shaft
            Rectangle()
                .fill(Color.red)
                .frame(width: 4, height: diameter/2 - 30)
                .offset(y: -(diameter/2 - 30)/2)
                .rotationEffect(.degrees(pointerAngle))
            
            // Pointer tip
            Circle()
                .fill(Color.red)
                .frame(width: 12, height: 12)
        }
    }
}