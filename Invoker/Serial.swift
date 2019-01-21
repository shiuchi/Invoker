//
//  Serial.swift
//  Invoker
//
//  Created by shiuchi on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

public final class Serial {
    private var commands: [Command] = []
    public weak var receiver: CommandReceiver?
    private(set) public var isExcuting: Bool = false
    private (set) public var isSuspended: Bool = false
    
    public init() {
    }
}

extension Serial: Command {
    
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
        guard isExcuting, !isSuspended else { return }
        
        if let command = commands.first {
            command.receiver = self
            command.execute()
        }
    }
}

extension Serial: CommandInvoker {
    @discardableResult public func add(_ command: Command) -> Serial {
        commands.append(command)
        return self
    }
    
    @discardableResult public func add(_ commands: [Command]) -> Serial {
        self.commands.append(contentsOf: commands)
        return self
    }
    
    
    /// Cancel all Commands and discard Commands
    public func cancel() {
        isExcuting = false
        commands.removeAll()
    }
    
    
    /// Resume command execution
    /// After stopping the currently executing Command, stop Commands.
    public func suspend() {
        isSuspended = true
    }
    
    /// Resume command execution
    public func resume() {
        if isSuspended {
            isSuspended = false
            _execute()
        }
    }
    
    
}

extension Serial: CommandReceiver {
    
    public func onComplete(_ command: Command) {
        guard isExcuting else { return }
        
        commands.pop()
        if commands.isEmpty {
            complete()
        } else {
            _execute()
        }
    }
    
    private func complete() {
        isExcuting = false
        isSuspended = false
        receiver?.onComplete(self)
    }
}
