# Invoker
simple invoker for swift

## Description

Invoker provides a simple Command interface for swift.

## Features
* Support simple Command Pattern
* Simple interface, execute(), suspend(), resume()
* You can extend it by implementing the Command interface

## Example

```swift
// set receiver or set completion
serial.receiver = self
serial.completion({ [weak self] _ in
    print("end")
})

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
})

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
```

## Installation


## Author

shiuchi

## License

MIT
