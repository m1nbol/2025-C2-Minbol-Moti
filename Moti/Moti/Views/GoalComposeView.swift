//
//  GoalComposeView.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import SwiftUI
import SwiftData

struct GoalComposeView: View {
    @Binding var router: NavigationRouter
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var goalContext: String = ""
    @State private var dueDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Enter your Goal", text: $goalContext)
                    .autocorrectionDisabled()
                    .font(.mainTextSemiBold34)
                HStack {
                    DatePicker("", selection: $dueDate, displayedComponents: [.date])
                        .tint(.mainBlue)
                        .labelsHidden()
                    Spacer()
                }
                Divider()
                Text("You've selected a goal duration of \(dueDate.daysRemaining()) days")
            }
            .padding(.horizontal, 20)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        router.dismissSheet()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Goals")
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveGoal()
                        router.dismissSheet()
                    } label: {
                        Text("Save")
                    }
                }
            }
            .foregroundStyle(.mainBlue)
        }
    }
    
    private func saveGoal() {
        let newGoal = Goal(
            id: UUID(),
            context: goalContext,
            dueDate: dueDate,
            createdAt: Date(timeIntervalSinceNow: 0)
        )
        modelContext.insert(newGoal)
    }
}

//#Preview {
//    GoalComposeView()
//}
