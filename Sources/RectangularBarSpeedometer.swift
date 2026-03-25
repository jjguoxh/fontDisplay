import SwiftUI

struct RectangularBarSpeedometer: SpeedometerBase {
    let value: Double
    let selectedFontName: String
    let numberFontSize: CGFloat
    let unitFontSize: CGFloat
    let opacity: Double
    let scale: Double
    
    // 拖放状态管理
    @State private var numberOffset: CGSize = .zero
    @State private var unitOffset: CGSize = .zero
    @State private var isDraggingNumber: Bool = false
    @State private var isDraggingUnit: Bool = false
    
    // 初始化时加载保存的位置
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
        
        // 加载保存的位置数据
        _numberOffset = State(initialValue: loadNumberOffset())
        _unitOffset = State(initialValue: loadUnitOffset())
    }
    
    var body: some View {
        scaledAndOpaque(
            // 矩形条状HUD（包含数值和单位显示）
            rectangularBarHUD(width: 300, height: 120)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
    
    // 矩形条状HUD
    private func rectangularBarHUD(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            // 背景矩形（黑色）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black)
                .frame(width: width, height: height)
            
            // 边框（白色）
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white, lineWidth: 2)
                .frame(width: width, height: height)
            
            // 数值和单位显示（在顶部）
            VStack(spacing: 4) {
                // 数值（可拖放）
                Text("\(Int(value))")
                    .font(.custom(selectedFontName, size: numberFontSize))
                    .fontWeight(.bold)
                    .foregroundColor(isDraggingNumber ? .yellow : .white)
                    .offset(numberOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isDraggingNumber = true
                                numberOffset = gesture.translation
                            }
                            .onEnded { gesture in
                                isDraggingNumber = false
                                saveNumberOffset()
                            }
                    )
                
                // 单位（可拖放）
                Text("km/h")
                    .font(.custom(selectedFontName, size: unitFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(isDraggingUnit ? .yellow : .white)
                    .offset(unitOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isDraggingUnit = true
                                unitOffset = gesture.translation
                            }
                            .onEnded { gesture in
                                isDraggingUnit = false
                                saveUnitOffset()
                            }
                    )
            }
            .offset(y: -height/4) // 在矩形条上方
            
            // 12个细长矩形条
            HStack(spacing: 3) {
                ForEach(0..<12, id: \.self) { index in
                    let isActive = shouldHighlightBar(at: index)
                    
                    VStack(spacing: 2) {
                        // 矩形条（圆角设计）
                        RoundedRectangle(cornerRadius: 6)
                            .fill(isActive ? activeColorForBar(at: index) : Color.white.opacity(0.3))
                            .frame(width: 16, height: height/2 - 20)
                            .animation(.easeInOut(duration: 0.2), value: value)
                        
                        // 刻度值
                        Text("\(index * 10)")
                            .font(.custom(selectedFontName, size: 10))
                            .foregroundColor(isActive ? .white : .white.opacity(0.6))
                    }
                }
            }
            .offset(y: height/4) // 在矩形条下方
            
            // 当前值指示器
            currentValueIndicator(width: width, height: height)
        }
    }
    
    // 判断是否高亮指定位置的矩形条
    private func shouldHighlightBar(at index: Int) -> Bool {
        let barValue = Double(index) * 10.0
        return value >= barValue
    }
    
    // 获取矩形条的激活颜色
    private func activeColorForBar(at index: Int) -> Color {
        let normalizedIndex = Double(index) / 11.0 // 0.0 到 1.0
        
        if normalizedIndex <= 0.5 {
            // 绿色到黄色
            let progress = normalizedIndex * 2.0
            return Color(
                red: progress,
                green: 1.0,
                blue: 0.0
            )
        } else {
            // 黄色到红色
            let progress = (normalizedIndex - 0.5) * 2.0
            return Color(
                red: 1.0,
                green: 1.0 - progress,
                blue: 0.0
            )
        }
    }
    
    // 当前值指示器
    private func currentValueIndicator(width: CGFloat, height: CGFloat) -> some View {
        let indicatorPosition = (value / 120.0) * (width - 40) - (width - 40) / 2
        let barHeight = height/2 - 20
        
        return ZStack {
            // 指示器线（覆盖矩形条区域）
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: barHeight)
            
            // 指示器三角形（在顶部居中）
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: -6, y: -8))
                path.addLine(to: CGPoint(x: 6, y: -8))
                path.closeSubpath()
            }
            .fill(Color.red)
            .frame(width: 12, height: 8)
            .offset(y: -barHeight / 2 - 4) // 在竖线顶部居中
        }
        .offset(x: indicatorPosition, y: height/4) // 对齐到矩形条区域
    }
    
    // 保存数值位置到UserDefaults
    private func saveNumberOffset() {
        UserDefaults.standard.set(numberOffset.width, forKey: "rectangularHUD_numberOffset_width")
        UserDefaults.standard.set(numberOffset.height, forKey: "rectangularHUD_numberOffset_height")
    }
    
    // 保存单位位置到UserDefaults
    private func saveUnitOffset() {
        UserDefaults.standard.set(unitOffset.width, forKey: "rectangularHUD_unitOffset_width")
        UserDefaults.standard.set(unitOffset.height, forKey: "rectangularHUD_unitOffset_height")
    }
    
    // 从UserDefaults加载数值位置
    private func loadNumberOffset() -> CGSize {
        let width = UserDefaults.standard.double(forKey: "rectangularHUD_numberOffset_width")
        let height = UserDefaults.standard.double(forKey: "rectangularHUD_numberOffset_height")
        return CGSize(width: width, height: height)
    }
    
    // 从UserDefaults加载单位位置
    private func loadUnitOffset() -> CGSize {
        let width = UserDefaults.standard.double(forKey: "rectangularHUD_unitOffset_width")
        let height = UserDefaults.standard.double(forKey: "rectangularHUD_unitOffset_height")
        return CGSize(width: width, height: height)
    }
}