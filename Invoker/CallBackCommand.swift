//
//  CallBackCommand.swift
//  Invoker
//
//  Created by 志内 幸彦 on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

import Foundation

public class CallbackCommand<T, U> {
    weak public var receiver: CommandReceiver?
    public var isExcuting: Bool = false
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