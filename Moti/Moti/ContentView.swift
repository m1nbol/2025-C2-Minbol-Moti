//
//  ContentView.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import SwiftUI

struct ContentView: View {
    @State private var router = NavigationRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 20) {
                Button("GO TO BOARDS VIEW") {
                    router.push(.board)
                }
                Button("Go to details") {
                    router.push(.goalDetails)
                }
                Button("Go to GoalCompose") {
                    router.presentSheet(.goalCompose)
                }
                Button("Go to TaskCompose") {
                    router.presentSheet(.taskCompose)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .board:
                    BoardView(router: $router)
//                case .goalCompose:
//                    GoalComposeView(router: $router)
                case .goalDetails:
                    GoalDetailsView()
//                case .taskCompose:
//                    TaskComposeView()
                }
            }
            .navigationTitle("Home")
        }
        .sheet(item: $router.presentedSheet) { sheet in
            switch sheet {
            case .goalCompose:
                GoalComposeView(router: $router)
            case .taskCompose:
                TaskComposeView(router: $router)
            }
        }
    }
}

#Preview {
    ContentView()
}
