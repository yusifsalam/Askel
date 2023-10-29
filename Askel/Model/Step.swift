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
    var day: Int
    var count: Int
    
}
