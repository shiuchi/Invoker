//
//  Serial.swift
//  Invoker
//
//  Created by 志内 幸彦 on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

import Foundation

public final class Serial {
    private var commands: [Command] = []
    public weak var receiver: CommandReceiver?
    private(set) public var excuting: Bool = false
    
    public init() {
    }
}

extension Serial: Command {
    
    public func execute() {
        guard !excuting, !commands.isEmpty else {
            return
        }
        _execute()
    }
    
    private func _execute() {
        excuting = true
        if let command = commands.first {
            command.receiver = self
            command.execute()
        }
    }
}

extension Serial: CommandInvoker {
    public func add(_ command: Command) {
        commands.append(command)
    }
}

extension Serial: CommandReceiver {
    
    public func onComplete(_ command: Command) {
        commands.pop()
        if commands.isEmpty {
            excuting = false
            receiver?.onComplete(self)
        } else {
            _execute()
        }
    }
}
