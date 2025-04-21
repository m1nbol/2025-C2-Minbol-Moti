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
    
    @State private var showSaveAlert: Bool = false
    
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
                Group {
                    Text("목표 기간을")
                    +
                    Text(" \(dueDate.daysRemaining())일")
                        .font(.mainTextBold16)
                    +
                    Text("로 설정했어요.")
                }
                .font(.maintTextLight16)
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
//                        saveGoal()
//                        router.dismissSheet()
                        showSaveAlert = true
                    } label: {
                        Text("저장하기")
                            .font(.mainTextSemiBold18)
                    }
                }
            }
            .alert("목표를 신중하게 설정하세요.", isPresented: $showSaveAlert) {
                Button("취소", role: .cancel) {}
                Button("저장하기") {
                    saveGoal()
                    router.dismissSheet()
                }
            } message: {
                Text("한 번 저장하면 목표를 수정하거나 삭제할 수 없어요. 저장 전에 다시 한 번 확인해 주세요.")
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
