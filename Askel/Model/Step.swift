//
//  Step.swift
//  Askel
//
//  Created by Yusif Salam-zade on 29.10.2023.
//

import Foundation


struct Step: Identifiable {
    var id = UUID()
    var type: String
    var date: Date
    var count: Int
    
    var day: Int {
        Calendar.current.component(.day, from: date)
    }
    
}

let calendar = Calendar.current
let today = Date()
let month = calendar.dateComponents([.year, .month], from: today)

extension Step {
    static var sampleData: [Step] = [
        Step(type: "running", date: calendar.date(from: DateComponents(year: month.year, month: month.month, day: 1)) ?? today, count: 2500),
        Step(type: "running", date: calendar.date(from: DateComponents(year: month.year, month: month.month, day: 5)) ?? today, count: 15000),
        Step(type: "running", date: calendar.date(from: DateComponents(year: month.year, month: month.month, day: 15)) ?? today, count: 7153)
        
    ]
}
