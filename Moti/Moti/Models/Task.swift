//
//  Task.swift
//  Moti
//
//  Created by BoMin Lee on 4/16/25.
//

import Foundation
import SwiftData

@Model
class Task {
    @Attribute(.unique) var id: UUID
    
    var context: String
    var isChecked: Bool
    
    init(id: UUID, context: String, isChecked: Bool) {
        self.id = id
        self.context = context
        self.isChecked = isChecked
    }
}
