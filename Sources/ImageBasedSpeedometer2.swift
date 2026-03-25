import SwiftUI

struct ImageBasedSpeedometer2: SpeedometerBase {
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
                // 图像底盘 - 方形底盘
                squareDialBase(size: 250)
                
                // 指针
                squarePointer(size: 200)
                
                // 数值和单位显示
                valueAndUnitDisplay()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
    
    // 图像底盘 - 方形底盘
    private func squareDialBase(size: CGFloat) -> some View {
        ZStack {
            // 底盘背景（黑色方形）
            Rectangle()
                .fill(Color.black)
                .frame(width: size, height: size)
                .cornerRadius(8)
            
            // 边框（白色）
            Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: size, height: size)
                .cornerRadius(8)
            
            // 半圆形刻度盘（白色）
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(Color.white, lineWidth: 2)
                .frame(width: size - 40, height: size - 40)
                .rotationEffect(.degrees(180))
                .offset(y: -20)
            
            // 刻度标记（白色）
            ForEach(0..<7, id: \.self) { index in
                let angle = Double(index) * 30.0 - 90.0
                let scaleValue = Double(index) * 20.0
                
                VStack(spacing: 4) {
                    // 刻度线
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 2, height: 12)
                    
                    // 数字刻度
                    Text("\(Int(scaleValue))")
                        .font(.custom(selectedFontName, size: 12))
                        .foregroundColor(.white)
                }
                .offset(y: -(size - 40)/2 + 30)
                .rotationEffect(.degrees(angle))
            }
        }
    }
    
    // 方形指针
    private func squarePointer(size: CGFloat) -> some View {
        let pointerAngle = (value / 120.0) * 180.0 - 90.0
        
        return ZStack {
            // 指针轴心（红色小圆点）
            Circle()
                .fill(Color.red)
                .frame(width: 6, height: 6)
                .offset(y: -20)
            
            // 指针（红色）
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: (size - 40)/2 - 20)
                .offset(y: -((size - 40)/2 - 20)/2 - 20)
                .rotationEffect(.degrees(pointerAngle))
        }
    }
}