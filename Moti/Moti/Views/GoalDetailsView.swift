//
//  GoalDetailsView.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import SwiftUI
import Lottie

struct GoalDetailsView: View {
    @State private var router = NavigationRouter()
    @GestureState private var dragOffset: CGFloat = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    let goal: Goal
    @State private var dueDate: Date = Date()
    @State private var isTouching = false
    @StateObject private var controller = LottieController()
    
    @State private var selectedTask: Task?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            Text(goal.context)
                .font(.mainTextSemiBold34)
                .foregroundStyle(.mainBlue)
            VStack {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.buttonGray)
                            .frame(width: 150, height: 35)
                        Text("\(goal.dueDate, style: .date)")
                            .foregroundStyle(.mainBlue)
                    }
                    Spacer()
                }
                Divider()
            }
            
            HStack {
                Spacer()
                Group {
                    Text("Only")
                        .font(.maintTextLight16)
                    +
                    Text(" \(goal.daysRemaining) days")
                        .font(.mainTextBold16)
                    +
                    Text(" to go-keep going!")
                        .font(.maintTextLight16)
                }
                .foregroundStyle(.mainBlue)
                Spacer()
            }
            
            Spacer()
            
            ZStack {
                if let task = selectedTask {
                    LottieView(animationName: "checkAnimationColored", controller: controller)
                        .frame(width: 400, height: 400)
                    Text(isTouching || controller.isChecked ? "" : task.context)
                        .font(.mainTextMedium24)
                        .foregroundColor(.mainBlue)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if !isTouching {
                                        isTouching = true
                                        controller.playForward()
                                    }
                                }
                                .onEnded { _ in
                                    isTouching = false
                                    controller.playReverseToStart()
                                }
                        )
                }
            }
            //MARK: Swipe Code
            .contentShape(Rectangle()) // 스와이프 범위 확장
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        guard let tasks = goal.taskList, let current = selectedTask,
                              let index = tasks.firstIndex(of: current) else { return }
                        
                        let threshold: CGFloat = 50
                        if value.translation.width < -threshold, index < tasks.count - 1 {
                            // 👉 오른쪽으로 스와이프 → 다음 task
                            withAnimation {
                                selectedTask = tasks[index + 1]
                            }
                        } else if value.translation.width > threshold, index > 0 {
                            // 👈 왼쪽으로 스와이프 → 이전 task
                            withAnimation {
                                selectedTask = tasks[index - 1]
                            }
                        }
                    }
            )
            //Swipe Code 끝
            .onReceive(controller.$isChecked) { isChecked in
                if isChecked, let task = selectedTask, !task.isChecked {
                    task.isChecked = true
                }
            }
            .onChange(of: selectedTask) { _, newTask in
//                if let task = newTask {
//                    controller.isChecked = task.isChecked
//                }
                if let task = newTask {
                    if task.isChecked {
                        controller.isChecked = true
                        controller.animationView?.currentProgress = 1.0
                    } else {
                        controller.isChecked = false
                        controller.animationView?.currentProgress = 0.0
                    }
                }
            }
            
            Spacer()
            
            if let tasks = goal.taskList {
                ScrollViewReader { proxy in
                    //MARK: ScrollView
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(tasks) { task in
                                TaskBubbleView(
                                    task: task,
                                    isSelected: selectedTask == task,
                                    onTap: {
                                        selectedTask = task
                                    }
                                )
                            }
                            // ✅ “+” 추가 버튼 Bubble
    //                        VStack(spacing: 4) {
    //                            Button {
    //                                router.presentSheet(.taskCompose)
    //                            } label: {
    //                                Image(systemName: "plus")
    //                                    .font(.maintTextLight20)
    //                                    .frame(width: 40, height: 40)
    //                                    .background(
    //                                        Circle()
    //                                            .strokeBorder(Color.mainBlue, lineWidth: 2)
    //                                            .background(Circle().fill(Color.white))
    //                                    )
    //                                    .foregroundStyle(.mainBlue)
    //                            }
    //                            .buttonStyle(.plain)
    //                            Color.clear
    //                                .frame(height: 5)
    //                                .padding(.top, 5)
    //                        }
                            // 추가버튼 끝
                            
                            // ✅ “+” 추가 버튼 Bubble(Ivory BG Ver)
                            VStack(spacing: 4) {
                                Button {
                                    router.presentSheet(.taskCompose)
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.maintTextLight20)
                                        .frame(width: 40, height: 40)
                                        .background(
                                            Circle()
                                                .fill(.mainIvory)
                                        )
                                        .foregroundStyle(.mainBlue)
                                }
                                .buttonStyle(.plain)
                                
                                Color.clear
                                    .frame(height: 5)
                                    .padding(.top, 5)
                            }
                            .id("plusButton")
                            // 추가버튼 끝
                        }
                    }
                    .onAppear {
                        scrollProxy = proxy
                        // ✅ 진입 시 ➕ 버튼으로 스크롤
                        withAnimation {
                            proxy.scrollTo("plusButton", anchor: .trailing)
                        }
                    }
                }
                .onChange(of: goal.taskList?.count) { _, _ in
                    withAnimation {
                        scrollProxy?.scrollTo("plusButton", anchor: .trailing)
                    }
                }
                .onChange(of: selectedTask?.id) { _, newID in
                    guard let id = newID else { return }
                    withAnimation {
                        scrollProxy?.scrollTo(id, anchor: .center)
                    }
                }
            }
        }
        .sheet(item: $router.presentedSheet) { sheet in
            TaskComposeView(router: $router, goal: goal)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .onAppear {
            if selectedTask == nil, let tasks = goal.taskList, !tasks.isEmpty {
                selectedTask = tasks.last // 최신 항목 선택
            }
        }
    }
}

//#Preview {
//    GoalDetailsView(goal: Goal(id: UUID(), context: "건강한 삶 살기", dueDate: Date(timeIntervalSinceNow: 1000000), createdAt: Date(timeIntervalSinceNow: 0)))
//}
