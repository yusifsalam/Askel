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
    var monthlySteps: [Step] = []

    
    var runningSteps: Int = -1
    
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            requestAccess()
        } else {
            fatalError("health data not available")
        }
        
    }
    
    func requestAccess() {
        let steps = HKQuantityType(.stepCount)
        let workouts = HKObjectType.workoutType()
        let healthTypes: Set = [steps, workouts]
        
        Task {
            do {
                try await store.requestAuthorization(toShare: [], read: healthTypes)
                runningSteps = 0
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
                let dayAsNumber = Calendar.current.component(.day, from: sample.startDate)
                if var step = self.monthlySteps.first(where: { $0.day == dayAsNumber }) {
                    step.count += Int(runningSteps.doubleValue(for: HKUnit.count()))
                } else {
                    self.monthlySteps.append(Step(type: "running", date: sample.startDate, count: Int(runningSteps.doubleValue(for: HKUnit.count()))))
                }
                self.runningSteps += Int(runningSteps.doubleValue(for: HKUnit.count()))
            }
            print(self.monthlySteps)
        }
        store.execute(sampleQuery)
    }
}


