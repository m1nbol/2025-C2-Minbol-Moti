//
//  LottieController.swift
//  Moti
//
//  Created by BoMin Lee on 4/21/25.
//

import Lottie
import Combine

class LottieController: ObservableObject {
    var animationView: LottieAnimationView?
    @Published var isChecked: Bool = false

    func playForward() {
        guard let animationView, !isChecked else { return }

        animationView.stop()
        animationView.currentProgress = 0
        animationView.animationSpeed = 1.0
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { finished in
            if finished {
                self.isChecked = true
            }
        }
    }

    func playReverseToStart() {
        guard let animationView, !isChecked else { return }

        let current = animationView.realtimeAnimationProgress
        animationView.pause()
        animationView.animationSpeed = 1.0
        animationView.play(fromProgress: current, toProgress: 0, loopMode: .playOnce)
    }
}

