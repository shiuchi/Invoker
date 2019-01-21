//
//  Invoker.swift
//  Invoker
//
//  Created by shiuchi on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

public protocol Command: class {
    func execute()
    var receiver: CommandReceiver? { get set }
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
    var isExcuting: Bool { get }
    var isSuspended: Bool { get }
    @discardableResult func add(_ command: Command) -> Self
    @discardableResult func add(_ commands: [Command]) -> Self
    
    func cancel()
    func suspend()
    func resume()
}


// MARK: - short cut
public extension CommandInvoker {
    
    @discardableResult public func wait(_ delay: TimeInterval) -> Self {
        add(WaitCommand(delay))
        return self
    }
    
    @discardableResult public func call<T, U>(_ handler: @escaping (T) -> U, params: T ) -> Self {
        add(CallbackCommand(handler, params: params))
        return self
    }
    
    @discardableResult public func call<T>(_ handler: @escaping () -> T ) -> Self {
        add(CallbackCommand(handler, params: ()))
        return self
    }
    
    @discardableResult public func animate(
        duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil) -> Self {
        add(AnimateCommand(duration: duration, delay: delay, options: options, animations: animations, completion: completion))
        return self
    }
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

