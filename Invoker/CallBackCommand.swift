//
//  CallBackCommand.swift
//  Invoker
//
//  Created by shiuchi on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

public class CallbackCommand<T, U> {
    weak public var receiver: CommandReceiver?
    private let handler: (T) -> (U)
    private let params: T
    
    public init(_ handler: @escaping (T) -> U, params: T) {
        self.handler = handler
        self.params = params
    }
}


extension CallbackCommand: Command {
    
    public func execute() {
        _ = handler(params)
        receiver?.onComplete(self)
    }
}
