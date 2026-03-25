import SwiftUI

struct SegmentedProgressSpeedometer: SpeedometerBase {
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
                // Outer segmented progress ring
                segmentedProgressRing(diameter: 250)
                
                // Middle white ring
                baseCircleRing(diameter: 200)
                
                // Inner segmented progress ring
                segmentedProgressRing(diameter: 170, segmentCount: 8)
                
                // Numerical and unit display
                valueAndUnitDisplay()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
    
    // 分段进度条圆环
    private func segmentedProgressRing(diameter: CGFloat, segmentCount: Int = 12) -> some View {
        let segmentAngle = 360.0 / Double(segmentCount)
        let activeSegments = Int((value / 120.0) * Double(segmentCount))
        
        return ZStack {
            ForEach(0..<segmentCount, id: \.self) { index in
                if index < activeSegments {
                    // 激活的分段使用渐变颜色
                    Circle()
                        .trim(from: 0, to: 0.7) // 每个分段占70%的圆弧
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .fill(segmentGradientForValue(value, segmentIndex: index))
                        .frame(width: diameter, height: diameter)
                        .rotationEffect(.degrees(Double(index) * segmentAngle))
                } else {
                    // 未激活的分段使用灰色
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                        .frame(width: diameter, height: diameter)
                        .rotationEffect(.degrees(Double(index) * segmentAngle))
                }
            }
        }
    }
    
    // 分段渐变颜色
    private func segmentGradientForValue(_ value: Double, segmentIndex: Int) -> LinearGradient {
        let hue = Double(segmentIndex) / 12.0 // 基于分段索引创建色相变化
        let saturation = 0.8 + (value / 120.0) * 0.2
        
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: hue, saturation: saturation, brightness: 0.9),
                Color(hue: hue, saturation: saturation, brightness: 0.6)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}