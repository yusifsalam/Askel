//
//  HealthManager.swift
//  Askel
//
//  Created by Yusif Salam-zade on 1.10.2023.
//

import Foundation
import HealthKit

@Observable class HealthManager {
    
    let store = HKHealthStore()
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let workouts = HKObjectType.workoutType()
        let healthTypes: Set = [steps, workouts]
        
        Task {
            do {
                try await store.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("error fetching data", error)
            }
        }
    }
    
    func fetchRunningSteps() {
        let workouts = HKObjectType.workoutType()
        let endDate = Date()
        let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: endDate))
        
        let runningPredicate =  HKQuery.predicateForWorkouts(with: .running)
        let timeRangePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [runningPredicate, timeRangePredicate])
 
        let sampleQuery = HKSampleQuery(sampleType: workouts, predicate: predicates, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, result, error in
            guard let samples = result as? [HKWorkout], error == nil else {
                print("failed to fetch, error: \(String(describing: error?.localizedDescription))")
                return
            }
            for sample in samples {
                guard let runningSteps = sample.statistics(for: HKQuantityType(.stepCount))?.sumQuantity() else { return }
                print("running steps: \(runningSteps) on \(sample.startDate.formatted(date: .long, time: .shortened))")
            }
        }
        store.execute(sampleQuery)
    }
}
