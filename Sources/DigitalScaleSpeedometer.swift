import SwiftUI

struct DigitalScaleSpeedometer: SpeedometerBase {
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
                // Outer scale with digital numbers
                digitalScale(diameter: 250)
                
                // Progress ring
                progressRing(diameter: 220)
                
                // Inner circle with current value highlight
                currentValueHighlight(diameter: 180)
                
                // Numerical and unit display
                valueAndUnitDisplay()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
    
    // 辅助函数：获取激活颜色
    private func activeColorForValue(_ value: Double) -> Color {
        let normalizedValue = min(max(value / 120.0, 0.0), 1.0)
        
        if normalizedValue <= 0.5 {
            // 绿色到黄色
            let progress = normalizedValue * 2.0
            return Color(
                red: progress,
                green: 1.0,
                blue: 0.0
            )
        } else {
            // 黄色到红色
            let progress = (normalizedValue - 0.5) * 2.0
            return Color(
                red: 1.0,
                green: 1.0 - progress,
                blue: 0.0
            )
        }
    }
    
    // 数字刻度
    private func digitalScale(diameter: CGFloat) -> some View {
        ZStack {
            // Base circle
            baseCircleRing(diameter: diameter)
            
            // Digital number scale (every 30 km/h)
            ForEach(0..<5, id: \.self) { index in
                let angle = Double(index) * 72.0 - 90.0
                let scaleValue = Double(index) * 30.0
                let isActive = value >= scaleValue
                
                VStack(spacing: 8) {
                    // Scale marker
                    Circle()
                        .fill(isActive ? activeColorForValue(value) : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                    
                    // Digital number
                    Text("\(Int(scaleValue))")
                        .font(.custom(selectedFontName, size: 14))
                        .fontWeight(isActive ? .bold : .regular)
                        .foregroundColor(isActive ? .white : .white.opacity(0.6))
                }
                .offset(y: -diameter/2 + 40)
                .rotationEffect(.degrees(angle))
            }
            
            // Minor ticks (every 10 km/h)
            ForEach(0..<13, id: \.self) { index in
                let angle = Double(index) * 30.0 - 90.0
                let tickValue = Double(index) * 10.0
                let isActive = value >= tickValue
                
                Circle()
                    .fill(isActive ? activeColorForValue(value) : Color.white.opacity(0.2))
                    .frame(width: 4, height: 4)
                    .offset(y: -diameter/2 + 30)
                    .rotationEffect(.degrees(angle))
            }
        }
    }
    
    // 进度环
    private func progressRing(diameter: CGFloat) -> some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 6)
                .frame(width: diameter, height: diameter)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: arcRatio(for: value))
                .stroke(solidColorForValue(value), lineWidth: 6)
                .frame(width: diameter, height: diameter)
                .rotationEffect(.degrees(-90))
        }
    }
    
    // 纯色基于值
    private func solidColorForValue(_ value: Double) -> Color {
        switch value {
        case 0...30: return .blue
        case 30...50: return .yellow
        default: return .red
        }
    }
    
    // 当前值高亮
    private func currentValueHighlight(diameter: CGFloat) -> some View {
        ZStack {
            // Highlight circle
            Circle()
                .stroke(solidColorForValue(value), lineWidth: 3)
                .frame(width: diameter, height: diameter)
            
            // Value indicator
            ForEach(0..<3, id: \.self) { index in
                let angle = (value / 120.0) * 360.0 + Double(index) * 120.0
                
                Circle()
                    .fill(solidColorForValue(value))
                    .frame(width: 6, height: 6)
                    .offset(y: -diameter/2 + 3)
                    .rotationEffect(.degrees(angle))
            }
        }
    }
}