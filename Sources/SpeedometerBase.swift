import SwiftUI

protocol SpeedometerBase: View {
    var value: Double { get }
    var selectedFontName: String { get }
    var numberFontSize: CGFloat { get }
    var unitFontSize: CGFloat { get }
    var opacity: Double { get }
    var scale: Double { get }
}

struct SpeedometerConfig {
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
}

extension SpeedometerBase {
    // 计算颜色基于值
    func colorForValue(_ value: Double) -> Color {
        switch value {
        case 0...30: return .blue
        case 30...50: return .yellow
        default: return .red
        }
    }
    
    // 创建渐变颜色基于值
    func gradientForValue(_ value: Double) -> LinearGradient {
        let startColor: Color
        let endColor: Color
        
        switch value {
        case 0...30:
            startColor = .blue
            endColor = .blue.opacity(0.5)
        case 30...50:
            startColor = .green
            endColor = .yellow
        default:
            startColor = .orange
            endColor = .red
        }
        
        return LinearGradient(
            gradient: Gradient(colors: [startColor, endColor]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // 计算圆弧比例
    func arcRatio(for value: Double, maxValue: Double = 120) -> Double {
        return min(max(value / maxValue, 0), 1)
    }
    
    // 数值显示文本
    func valueText() -> Text {
        Text("\(Int(value))")
            .font(.custom(selectedFontName, size: numberFontSize))
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
    
    // 单位显示文本
    func unitText() -> Text {
        Text("km/h")
            .font(.custom(selectedFontName, size: unitFontSize))
            .fontWeight(.medium)
            .foregroundColor(.white)
    }
    
    // 数值和单位组合显示
    func valueAndUnitDisplay() -> some View {
        VStack(spacing: 8) {
            valueText()
            unitText()
        }
    }
    
    // 基础圆环样式
    func baseCircleRing(diameter: CGFloat, color: Color = .white) -> some View {
        Circle()
            .stroke(color, lineWidth: 4)
            .frame(width: diameter, height: diameter)
    }
    
    // 动态圆弧样式
    func dynamicArcRing(
        diameter: CGFloat,
        trimFrom: Double = 0,
        trimTo: Double? = nil,
        rotation: Double = 90
    ) -> some View {
        let arcTo = trimTo ?? arcRatio(for: value)
        
        return Circle()
            .trim(from: trimFrom, to: arcTo)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .fill(gradientForValue(value))
            .frame(width: diameter, height: diameter)
            .rotationEffect(.degrees(rotation))
    }
    
    // 缩放和透明度修饰符
    func scaledAndOpaque(_ content: some View) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
    }
}