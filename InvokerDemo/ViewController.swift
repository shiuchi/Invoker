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
    var image: TestView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = TestView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(image!)
        
        // set receiver
        serial.receiver = self
        
        // add command to Serial
        serial.add(CallbackCommand(trace, params: ("a")))
            .add(WaitCommand(1))
            .add(CallbackCommand(trace, params: ("b")))
            .add(WaitCommand(1))
            .add(CallbackCommand(trace, params: ("c")))
        
        
        // use short cut
        serial.call(trace, params: ("d"))
            .wait(1)
            .call(trace, params: ("e"))
        
        // suspend and resume
        serial.call({ [weak self] in
            self?.serial.suspend()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                self?.serial.resume()
            })
        }, params: ())
        
        // add Parallel to Serial
        let parallel = Parallel()
        parallel.add(CallbackCommand(trace, params: ("1")))
        parallel.add(CallbackCommand(trace, params: ("2")))
        parallel.add(CallbackCommand(trace, params: ("3")))
        serial.add(parallel)
        
        // use AnimateCommand
        let animate = AnimateCommand(duration: 0.5, delay:0.5, options: .curveEaseIn, animations: {
            self.image?.frame.origin.x = 100
            self.image?.frame.origin.y = 300
            self.image?.backgroundColor = UIColor.blue
        }, completion: { _ in
            self.image?.removeFromSuperview()
            self.image = nil
        })
        
        serial.add(animate)
            .call(trace, params: ("end"))
            .execute()
        
        
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
