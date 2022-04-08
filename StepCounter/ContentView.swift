//
//  ContentView.swift
//  StepCounter
//
//  Created by Tatsuya Moriguchi on 4/7/22.
//

import SwiftUI

import HealthKit

struct ContentView: View {
    
    private var healthStore: HealthStore?
    init() {
        healthStore = HealthStore()
    }
    
    // To store rate data, this goes to VM if using MVVM
    @State private var steps: [Step] = [Step]()
    
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        // .enumerationStatistics(from:, to:), .sources(), .statistics(), statistics(for: ).
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in

            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)

        }
        

    }
    
    var body: some View {
        List(steps, id: \.id) { step in
            Text("\(step.count)")
            Text(step.date, style: .date)
                .opacity(0.5)
        }
        
        // Display Authorization Request
            .onAppear() {
                if let healthStore = healthStore {
                    healthStore.requestAuthorization { (success) in
                        
                        if success {
                            healthStore.calculateStep { statisticsCollection in
                                if let statisticsCollection = statisticsCollection {
                                    // update the UI
                                    updateUIFromStatistics(statisticsCollection)
                                }
                            }
                        }
                    }
                }
            }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
