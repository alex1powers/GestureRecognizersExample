//
//  LongTapView.swift
//  GestureRecognizer
//
//  Created by Alexander Goremykin on 28.06.2018.
//  Copyright © 2018 Alexander Goremykin. All rights reserved.
//

import Foundation
import UIKit

class LongTapView: UIView {

    // MARK: - Public Properties

    var onLongTap: ((UITouch) -> Void)?

    // MARK: - Public Methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        touches
            .filter { delayedTouchesHandlers[$0] == nil }
            .forEach { touch in
                let workItem = DispatchWorkItem { [weak self] in self?.onLongTap?(touch) }
                delayedTouchesHandlers[touch] = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
            }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        touches.forEach {
            delayedTouchesHandlers[$0]?.cancel()
            delayedTouchesHandlers[$0] = nil
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        touches.forEach {
            delayedTouchesHandlers[$0]?.cancel()
            delayedTouchesHandlers[$0] = nil
        }
    }

    // MARK: - Private Properties

    private var delayedTouchesHandlers: [UITouch: DispatchWorkItem] = [:]
  
}
