//
//  Parallel.swift
//  Invoker
//
//  Created by shiuchi on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

import Foundation


public final class Parallel {
    private var commands: [Command] = []
    private(set) public var isExcuting: Bool = false
    public weak var receiver: CommandReceiver?
    private var isCancelled: Bool = false
    
    public init() {
    }
}

extension Parallel: Command {
    public func execute() {
        guard !isExcuting, !commands.isEmpty else {
            return
        }
        
        _execute()
    }
    
    private func _execute() {
        isExcuting = true
        commands.forEach { command in
            command.receiver = self
            command.execute()
        }
    }
}

extension Parallel: CommandReceiver {
    
    public func onComplete(_ command: Command) {
        if isCancelled {
            return
        }
        
        commands.removeAll(where: {command.id == $0.id})
        if commands.isEmpty {
            isExcuting = false
            receiver?.onComplete(self)
        }
    }
    
}

extension Parallel: CommandInvoker {
    @discardableResult public func add(_ command: Command) -> Parallel {
        commands.append(command)
        return self
    }
    
    @discardableResult public func add(_ commands: [Command]) -> Parallel {
        self.commands.append(contentsOf: commands)
        return self
    }
    
    public func release() {
        commands.removeAll()
    }
}
