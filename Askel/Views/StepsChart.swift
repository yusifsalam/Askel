//
//  StepsChart.swift
//  Askel
//
//  Created by Yusif Salam-zade on 29.10.2023.
//

import SwiftUI
import Charts


struct StepsChart: View {
    let data: [Step]
   
    var body: some View {
        Chart {
            ForEach(data) { step in
                BarMark(x: .value("Day", step.day), y: .value("", step.count))
            }
        }
        .chartXAxis {
            AxisMarks(values: [1, 5, 10, 15, 20, 25, 30, 34]) {
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .padding()
    }
}

#Preview {
    StepsChart(data: Step.sampleData)
}
