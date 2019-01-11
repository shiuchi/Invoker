//
//  AnimateCommand.swift
//  Invoker
//
//  Created by shiuchi on 2019/01/11.
//  Copyright © 2019 shiuchi. All rights reserved.
//

import UIKit

public class AnimateCommand: Command {
    weak public var receiver: CommandReceiver?
    private(set) public var isExcuting: Bool = false
    private var animations: () -> Void
    private var duration: TimeInterval
    private var delay: TimeInterval
    private var options: UIView.AnimationOptions
    private var completion: ((Bool) -> Void)?
    
    public init(
        duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        self.duration = duration
        self.delay = delay
        self.options = options
        self.animations = animations
        self.completion = completion
    }
    
    public func execute() {
        isExcuting = true
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: { [weak self] success in
                guard let self = self else { return }
                self.isExcuting = false
                self.completion?(success)
                self.receiver?.onComplete(self)
            }
        )
    }
}
