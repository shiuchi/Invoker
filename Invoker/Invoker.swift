//
//  Invoker.swift
//  Invoker
//
//  Created by 志内 幸彦 on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

import Foundation

public protocol Command: class {
    func execute()
    var receiver: CommandReceiver? { get set }
    var isExcuting: Bool { get }
    var id: ObjectIdentifier { get }
}

public extension Command {
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}

public protocol CommandReceiver: class {
    func onComplete(_ command: Command)
}

public protocol CommandInvoker {
    func add(_ command: Command)
}


internal extension Array {
    
    @discardableResult
    mutating func pop() -> Element? {
        if self.isEmpty {
            return nil
        } else {
            return self.removeFirst()
        }
    }
}