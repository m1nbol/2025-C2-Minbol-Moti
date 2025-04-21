//
//  Goal.swift
//  Moti
//
//  Created by BoMin Lee on 4/16/25.
//

import Foundation
import SwiftData

@Model
class Goal {
    @Attribute(.unique) var id: UUID
    
    var context: String
    var dueDate: Date
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade) var taskList: [Task]? = []
    
    init(id: UUID, context: String, dueDate: Date, createdAt: Date, taskList: [Task]? = nil) {
        self.id = id
        self.context = context
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.taskList = taskList
    }
}

extension Goal {
    func addTask(_ task: Task) {
        if taskList == nil {
            taskList = []
        }
        taskList?.append(task)
    }
    
    var daysRemaining: Int {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let due = calendar.startOfDay(for: dueDate)

        let components = calendar.dateComponents([.day], from: now, to: due)
        return components.day ?? 0
    }
}
