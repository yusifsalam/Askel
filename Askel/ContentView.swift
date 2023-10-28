//
//  ContentView.swift
//  Askel
//
//  Created by Yusif Salam-zade on 1.10.2023.
//

import SwiftUI
import Charts

struct ContentView: View {
    @Environment(HealthManager.self) private var manager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if manager.runningSteps == -1 {
                    Image(systemName: "exclamationmark.lock.fill")
                        .font(.largeTitle)
                    VStack {
                        Text("No HealthKit access!")
                            .font(.headline)
                        
                        Text("Please allow Askel to read your steps and workouts")
                            .font(.subheadline)
                    }
                    
                    
                } else {
                    Text("Running steps: \(manager.runningSteps)")
                    Chart {
                        ForEach(manager.monthlySteps) { step in
                            BarMark(x: .value("Day", step.day), y: .value("", step.count))
                        }
                    }
                    .chartXScale(domain: [1,31])
                }
            }
            .padding()
            .onAppear {
                manager.fetchRunningSteps()
            }
            .navigationTitle("Askel")
        }
    }
    
    
}

#Preview {
    ContentView()
        .environment(HealthManager())
}
