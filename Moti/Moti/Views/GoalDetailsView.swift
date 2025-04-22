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
    @Environment(\.modelContext) private var modelContext
    
    @GestureState private var dragOffset: CGFloat = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @Bindable var goal: Goal
    @State private var selectedTask: Task?
    @State private var dueDate: Date = Date()
    
    @State private var isTouching = false
    @State private var showDeleteButton = false
    @State private var showDeleteAlert = false
    @StateObject private var controller = LottieController()
    
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
                    if goal.daysRemaining > 0 {
                        Text(" \(goal.daysRemaining)일")
                            .font(.mainTextBold16)
                        +
                        Text(" 남았어요. 끝까지 함께해요!")
                            .font(.maintTextLight16)
                    } else if goal.daysRemaining == 0 {
                        Text("목표일이에요! 달성하셨나요?")
                            .font(.mainTextBold16)
                    } else {
                        Text("목표를 달성하셨나요?")
                            .font(.mainTextBold16)
                    }
                }
                .foregroundStyle(.mainBlue)
                Spacer()
            }
            
            Spacer()
            
            ZStack {
                if let task = selectedTask {
                    
                    LottieView(animationName: "checkAnimationColored", controller: controller)
                    //                        .frame(width: 400, height: 400)
                        .frame(maxWidth: .infinity)
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
                                showDeleteButton = false
                            }
                        } else if value.translation.width > threshold, index > 0 {
                            // 👈 왼쪽으로 스와이프 → 이전 task
                            withAnimation {
                                selectedTask = tasks[index - 1]
                                showDeleteButton = false
                            }
                        }
                        
                        let thresholdVertical: CGFloat = 30
                        withAnimation {
                            if value.translation.height < -thresholdVertical {
                                showDeleteButton = true
                            } else if value.translation.height > thresholdVertical {
                                showDeleteButton = false
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
            
            if let currentTask = selectedTask {
                if currentTask.isChecked {
                    HStack {
                        Spacer()
                        Text(currentTask.context)
                            .font(.mainTextMedium20)
                            .foregroundStyle(.mainGray)
                            .transition(.opacity)
                        Spacer()
                    }
                }
            }
            
            if showDeleteButton {
                HStack {
                    Spacer()
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .frame(width: 40, height: 40)
                    }
                    .alert("정말 삭제하시겠어요?", isPresented: $showDeleteAlert) {
                        Button("취소", role: .cancel) {}
                        Button("삭제", role: .destructive) {
                            deleteSelectedTask()
                        }
                    } message: {
                        Text("삭제한 할 일은 복구할 수 없습니다.")
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
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
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
//        .frame(maxWidth: .infinity)
        .sheet(item: $router.presentedSheet) { sheet in
            TaskComposeView(router: $router, goal: goal)
        }
//        .border(.red, width: 20)
        .onAppear {
            if selectedTask == nil, let tasks = goal.taskList, !tasks.isEmpty {
                selectedTask = tasks.last // 최신 항목 선택
            }
        }
    }
    
    private func deleteSelectedTask() {
        guard let task = selectedTask,
              var tasks = goal.taskList,
              let index = tasks.firstIndex(of: task) else { return }
        
        modelContext.delete(task)
        
        tasks.remove(at: index)
        goal.taskList = tasks
        
        if tasks.indices.contains(index) {
            selectedTask = tasks[index]
            showDeleteButton = false
        } else if tasks.indices.contains(index-1) {
            selectedTask = tasks[index-1]
            showDeleteButton = false
        } else {
            showDeleteButton = false
            selectedTask = nil
        }
    }
}

//#Preview {
//    GoalDetailsView(goal: Goal(id: UUID(), context: "건강한 삶 살기", dueDate: Date(timeIntervalSinceNow: 1000000), createdAt: Date(timeIntervalSinceNow: 0)))
//}
