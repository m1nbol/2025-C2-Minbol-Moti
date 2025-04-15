//
//  GoalComposeView.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import SwiftUI

struct GoalComposeView: View {
    @Binding var router: NavigationRouter
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("enter your goal")
                    .foregroundStyle(.mainGray)
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
                        .foregroundStyle(.mainBlue)
                    }
                }
            }
        }
    }
}

//#Preview {
//    GoalComposeView()
//}
