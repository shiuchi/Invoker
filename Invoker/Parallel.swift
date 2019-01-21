//
//  Parallel.swift
//  Invoker
//
//  Created by shiuchi on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

public final class Parallel {
    private var commands: [Command] = []
    private(set) public var isExcuting: Bool = false
    private (set) public var isSuspended: Bool = false
    public weak var receiver: CommandReceiver?
    
    public init() {
    }
}

extension Parallel: Command {
    public func execute() {
        guard !isExcuting else {
            return
        }
        
        if commands.isEmpty {
            complete()
            return
        }
        
        isExcuting = true
        _execute()
    }
    
    private func _execute() {
        guard isExcuting else { return }
        commands.forEach { command in
            command.receiver = self
            command.execute()
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
    
    public func cancel() {
        isExcuting = false
        commands.removeAll()
    }
    
    
    /// Parallel does not support this function
    public func suspend() {
    }
    
    /// Parallel does not support this function
    public func resume() {
    }
}

extension Parallel: CommandReceiver {
    
    public func onComplete(_ command: Command) {
        guard isExcuting else { return }
        
        commands.removeAll(where: {command.id == $0.id})
        if commands.isEmpty {
            complete()
        }
    }
    
    private func complete() {
        isExcuting = false
        receiver?.onComplete(self)
    }
}
