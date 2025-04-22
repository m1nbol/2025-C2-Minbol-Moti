//
//  FontManager.swift
//  Moti
//
//  Created by BoMin Lee on 4/15/25.
//

import Foundation
import SwiftUI

extension Font {
    enum Pretend {
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        
        var value: String {
            switch self {
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static var maintTextLight16: Font {
        return .pretend(type: .light, size: 16)
    }
    
    static var maintTextLight20: Font {
        return .pretend(type: .light, size: 20)
    }
    
    static var maintTextRegular20: Font {
        return .pretend(type: .regular, size: 20)
    }
    
    static var mainTextMedium16: Font {
        return .pretend(type: .medium, size: 16)
    }
    
    static var mainTextMedium20: Font {
        return .pretend(type: .medium, size: 20)
    }
    
    static var mainTextMedium24: Font {
        return .pretend(type: .medium, size: 24)
    }
    
    static var mainTextSemiBold18: Font {
        return .pretend(type: .semibold, size: 18)
    }
    
    static var mainTextSemiBold34: Font {
        return .pretend(type: .semibold, size: 34)
    }
    
    static var mainTextBold16: Font {
        return .pretend(type: .bold, size: 16)
    }

}
