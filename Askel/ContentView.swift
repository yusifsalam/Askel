//
//  ContentView.swift
//  Askel
//
//  Created by Yusif Salam-zade on 1.10.2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(HealthManager.self) private var manager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            manager.fetchRunningSteps()
        }
    }
}

#Preview {
    ContentView()
        .environment(HealthManager())
}
