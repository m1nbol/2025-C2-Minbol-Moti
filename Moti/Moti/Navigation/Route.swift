//
//  Route.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case goalDetails(goal: Goal)
}

enum SheetRoute: Identifiable, Hashable {
    case goalCompose
    case taskCompose
    
    var id: String {
        switch self {
        case .goalCompose: return "goalCompose"
        case .taskCompose: return "taskCompose"
        }
    }
}
