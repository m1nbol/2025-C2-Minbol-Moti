//
//  TaskBubble.swift
//  Moti
//
//  Created by BoMin Lee on 4/21/25.
//

import SwiftUI

struct TaskBubbleView: View {
    let task: Task
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            Button(action: onTap) {
                Text(task.context.isEmpty ? "?" : String(task.context.prefix(1)))
                    .font(.maintTextLight20)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(task.isChecked ? Color.mainBlue : Color.mainGray)
                    )
                    .foregroundStyle(.mainIvory)
            }
            .buttonStyle(.plain)
            .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)

            // 노란 밑줄
            if isSelected {
                Rectangle()
                    .fill(Color.yellow)
                    .frame(height: 5)
                    .cornerRadius(2.5)
                    .padding(.top, 5)
            } else {
                Color.clear
                    .frame(height: 5)
                    .padding(.top, 5)
            }
        }
        
    }
}
