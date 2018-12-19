//
//  Parallel.swift
//  Invoker
//
//  Created by 志内 幸彦 on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

import Foundation


public final class Parallel {
    private var commands: [Command] = []
    private(set) public var excuting: Bool = false
    public weak var receiver: CommandReceiver?
    
    public init() {
    }
}

extension Parallel: Command {
    public func execute() {
        guard !excuting, !commands.isEmpty else {
            return
        }
        
        _execute()
    }
    
    private func _execute() {
        excuting = true
        commands.forEach { command in
            command.receiver = self
            command.execute()
        }
    }
}

extension Parallel: CommandReceiver {
    
    public func onComplete(_ command: Command) {
        commands.removeAll(where: {command.id == $0.id})
        if commands.isEmpty {
            excuting = false
            receiver?.onComplete(self)
        }
    }
    
}

extension Parallel: CommandInvoker {
    public func add(_ command: Command) {
        commands.append(command)
    }
}
