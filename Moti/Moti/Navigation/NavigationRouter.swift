//
//  NavigationRouter.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class NavigationRouter {
    // 네비게이션 경로 저장 변수
    var path = NavigationPath()
    var presentedSheet: SheetRoute? = nil
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func reset() {
        path = NavigationPath()
    }
    
    func presentSheet(_ sheet: SheetRoute) {
        presentedSheet = sheet
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
}
