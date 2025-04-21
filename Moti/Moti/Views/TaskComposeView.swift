//
//  TaskComposeView.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import SwiftUI

struct TaskComposeView: View {
    @Binding var router: NavigationRouter
    @Bindable var goal: Goal
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var taskContext: String = ""
    @State private var isChecked: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter your Task", text: $taskContext)
                    .autocorrectionDisabled()
                    .font(.mainTextSemiBold34)
            }
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
                        // 저장해야 함
                        saveTask()
                        router.dismissSheet()
                    } label: {
                        Text("Save")
                    }
                }
            }
            .foregroundStyle(.mainBlue)
        }
    }
    
    private func saveTask() {
        let newTask = Task(
            id: UUID(),
            context: taskContext,
            isChecked: isChecked
        )
        modelContext.insert(newTask)
        goal.addTask(newTask)
    }
}

//#Preview {
//    TaskComposeView()
//}
