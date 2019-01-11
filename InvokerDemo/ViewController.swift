//
//  ViewController.swift
//  InvokerDemo
//
//  Created by shiuchi on 2018/12/18.
//  Copyright © 2018年 shiuchi. All rights reserved.
//

import UIKit
import Invoker

class ViewController: UIViewController {

    let serial = Serial()
    var image: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = TestView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(image!)
        
        serial.add(CallbackCommand(trace, params: ("a")))
            .add(WaitCommand(1))
            .add(CallbackCommand(trace, params: ("b")))
            .add(WaitCommand(1))
            .add(CallbackCommand(trace, params: ("c")))
        
        let parallel = Parallel()
        parallel.add(CallbackCommand(trace, params: ("d")))
        parallel.add(CallbackCommand(trace, params: ("e")))
        parallel.add(CallbackCommand(trace, params: ("f")))
        serial.add(parallel)
        
        let animate = AnimateCommand(duration: 0.5, delay:0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.image?.frame.origin.x = 100
            self.image?.frame.origin.y = 300
            self.image?.backgroundColor = UIColor.blue
        }, completion: { _ in
            self.image?.removeFromSuperview()
        })
        
        serial.add(animate)
        serial.add(CallbackCommand(trace, params: ("end")))
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
    }
}

class TestView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("TestView deinit")
    }
}
