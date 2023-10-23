//
//  AskelApp.swift
//  Askel
//
//  Created by Yusif Salam-zade on 1.10.2023.
//

import SwiftUI

@main
struct AskelApp: App {
    @State var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(manager)
        }
    }
}
