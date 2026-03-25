import SwiftUI

struct ImageBasedSpeedometer1: SpeedometerBase {
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
                // 图像底盘 - 简单的黑色圆形底盘
                imageDialBase(diameter: 250)
                
                // 指针
                pointer(diameter: 200)
                
                // 数值和单位显示
                valueAndUnitDisplay()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
    
    // 图像底盘 - 简单的黑色圆形底盘
    private func imageDialBase(diameter: CGFloat) -> some View {
        ZStack {
            // 底盘背景（黑色）
            Circle()
                .fill(Color.black)
                .frame(width: diameter, height: diameter)
            
            // 外圈（白色边框）
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: diameter, height: diameter)
            
            // 刻度标记（白色）
            ForEach(0..<12, id: \.self) { index in
                let angle = Double(index) * 30.0 - 90.0
                let isMajorTick = index % 3 == 0
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: isMajorTick ? 3 : 2, height: isMajorTick ? 15 : 10)
                    .offset(y: -diameter/2 + (isMajorTick ? 20 : 25))
                    .rotationEffect(.degrees(angle))
            }
            
            // 数字刻度（白色）
            ForEach(0..<4, id: \.self) { index in
                let angle = Double(index) * 90.0 - 90.0
                let scaleValue = Double(index) * 30.0
                
                Text("\(Int(scaleValue))")
                    .font(.custom(selectedFontName, size: 14))
                    .foregroundColor(.white)
                    .offset(y: -diameter/2 + 40)
                    .rotationEffect(.degrees(angle))
            }
        }
    }
    
    // 指针
    private func pointer(diameter: CGFloat) -> some View {
        let pointerAngle = (value / 120.0) * 270.0 - 135.0
        
        return ZStack {
            // 指针轴心（红色小圆点）
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
            
            // 指针（红色）
            Rectangle()
                .fill(Color.red)
                .frame(width: 3, height: diameter/2 - 30)
                .offset(y: -(diameter/2 - 30)/2)
                .rotationEffect(.degrees(pointerAngle))
        }
    }
}