import SwiftUI

@main
struct FontDisplayApp: App {
    var body: some Scene {
        WindowGroup("字体显示应用") {
            ContentView()
                .background(Color.black)
        }
        .windowStyle(DefaultWindowStyle())
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .saveItem) {}
        }
    }
}