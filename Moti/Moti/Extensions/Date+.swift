//
//  Date+.swift
//  Moti
//
//  Created by BoMin Lee on 4/20/25.
//

import Foundation

extension Date {
    func daysRemaining(from baseDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        let from = calendar.startOfDay(for: baseDate)
        let to = calendar.startOfDay(for: self)

        let components = calendar.dateComponents([.day], from: from, to: to)
        return components.day ?? 0
    }
}
