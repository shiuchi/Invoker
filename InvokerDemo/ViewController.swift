//
//  ViewController.swift
//  InvokerDemo
//
//  Created by 志内 幸彦 on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

import UIKit
import Invoker

class ViewController: UIViewController {

    let serial = Serial()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        serial.add(CallbackCommand(trace, params: ("a")))
        serial.add(WaitCommand(2))
        serial.add(CallbackCommand(trace, params: ("b")))
        serial.add(WaitCommand(2))
        serial.add(CallbackCommand(trace, params: ("c")))
        
        let parallel = Parallel()
        parallel.add(CallbackCommand(trace, params: ("d")))
        parallel.add(CallbackCommand(trace, params: ("e")))
        parallel.add(CallbackCommand(trace, params: ("f")))
        serial.add(parallel)
        
        serial.receiver = self
        serial.execute()
    }
    
    func trace(str: String) {
        print(str)
    }
}


extension ViewController: CommandReceiver {
    func onComplete(_ command: Command) {
        print(command)
        command.execute()
    }
}
