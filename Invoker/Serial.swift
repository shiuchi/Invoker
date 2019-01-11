//
//  Serial.swift
//  Invoker
//
//  Created by shiuchi on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

import Foundation

public final class Serial {
    private var commands: [Command] = []
    public weak var receiver: CommandReceiver?
    private(set) public var isExcuting: Bool = false
    private var isCancelled: Bool = false
    
    public init() {
    }
}

extension Serial: Command {
    
    public func execute() {
        guard !isExcuting, !commands.isEmpty else {
            return
        }
        _execute()
    }
    
    private func _execute() {
        isExcuting = true
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
    
    public func release() {
        isCancelled = true
        commands.removeAll()
    }
}

extension Serial: CommandReceiver {
    
    public func onComplete(_ command: Command) {
        if isCancelled {
            return
        }
        
        commands.pop()
        if commands.isEmpty {
            isExcuting = false
            receiver?.onComplete(self)
        } else {
            _execute()
        }
    }
}
