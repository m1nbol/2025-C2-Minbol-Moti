//
//  MotiApp.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import SwiftUI
import SwiftData

@main
struct MotiApp: App {
    var body: some Scene {
        WindowGroup {
            BoardView()
        }
        .modelContainer(for: Goal.self)
    }
}
