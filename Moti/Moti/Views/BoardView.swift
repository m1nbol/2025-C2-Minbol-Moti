//
//  BoardView.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import SwiftUI
import UIKit
import SwiftData

struct BoardView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var router = NavigationRouter()
    @Query/*(sort: \Goal.createdAt, order: .reverse)*/ private var goals: [Goal]
    
    @State private var goalToDelete: Goal?
    @State private var showDeleteAlert: Bool = false

    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.mainBlue]
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                ForEach(goals) { goal in
                    Button {
                        router.push(.goalDetails(goal: goal))
                    } label: {
                        HStack {
                            Text(goal.context)
                                .font(.maintTextLight20)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.vertical, 10)
                    }
//                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                        Button {
//                            goalToDelete = goal
//                            showDeleteAlert = true
//                        } label: {
//                            Label("삭제", systemImage: "trash")
//                        }
//                        .tint(.red)
//                    }
                }
            }
            .listStyle(.plain)
            
//            .alert("이 목표를 정말 삭제하시겠습니까?", isPresented: $showDeleteAlert, actions: {
//                Button("취소", role: .cancel) { }
//                Button("삭제", role: .destructive) {
//                    if let goal = goalToDelete {
//                        modelContext.delete(goal)
//                        goalToDelete = nil
//                    }
//                }
//            }, message: {
//                if let goal = goalToDelete {
//                    Text("\"\(goal.context)\" 목표가 완전히 삭제됩니다.")
//                }
//            })
            
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button {
                        router.presentSheet(.goalCompose)
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(.mainBlue)
                    }
                })
            }
            
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .goalDetails(let goal):
                    GoalDetailsView(goal: goal)
                    
                }
            }
        }
        .sheet(item: $router.presentedSheet) { sheet in
            GoalComposeView(router: $router)
        }
//        .border(.blue, width: 10)
    }
}

#Preview {
    BoardView()
}
