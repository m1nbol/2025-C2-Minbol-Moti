//
//  BoardView.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import SwiftUI

struct BoardView: View {
    @Binding var router: NavigationRouter
    
    var body: some View {
        VStack {
            Text("this is board view")
            Button("Exit") {
                router.pop()
            }
        }
    }
}

//#Preview {
//    BoardView()
//}
