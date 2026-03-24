import SwiftUI

struct InnerColoredSpeedometer: SpeedometerBase {
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
                // Outer circle ring (white)
                baseCircleRing(diameter: 250)
                
                // Inner circle ring (dynamic arc with color based on value)
                dynamicArcRing(diameter: 200)
                
                // Numerical and unit display
                valueAndUnitDisplay()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
}