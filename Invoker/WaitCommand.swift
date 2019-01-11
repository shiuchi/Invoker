//
//  WaitCommand.swift
//  Invoker
//
//  Created by shiuchi on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

import Foundation


public class WaitCommand: Command {
    weak public var receiver: CommandReceiver?
    private(set) public var isExcuting: Bool = false
    private let delay: Double
    
    public init(_ delay: Double) {
        self.delay = delay
    }
    
    public func execute() {
        isExcuting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            self.isExcuting = false
            self.receiver?.onComplete(self)
        }
    }
    
}
