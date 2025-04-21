//
//  LottieView.swift
//  Moti
//
//  Created by BoMin Lee on 4/21/25.
//

import SwiftUI
import Lottie
import UIKit

struct LottieView: UIViewRepresentable {
    let animationName: String
    @ObservedObject var controller: LottieController

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        controller.animationView = animationView // 연결

        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // 자동 재생 없음
    }
}
