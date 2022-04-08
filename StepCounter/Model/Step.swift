//
//  Step.swift
//  StepCounter
//
//  Created by Tatsuya Moriguchi on 4/7/22.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}
