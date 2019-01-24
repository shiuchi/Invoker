//
//  SerialTest.swift
//  InvokerTests
//
//  Created by shiuchi on 2019/01/22.
//  Copyright © 2019 shiuchi. All rights reserved.
//

import XCTest

class SerialTest: XCTestCase {

    let serial =  Serial()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAdd() {
        serial.cancel()
        let expect = expectation(description: "wating for serial command complete")
        serial.call({
            print("a")
        })
        .wait(1)
        .call({
            print("b")
        })
        .wait(1)
        .call({
            print("c")
        })
        .completion({ _ in
            XCTAssertEqual(self.serial.count, 0)
            expect.fulfill()
        })
        
        XCTAssertEqual(serial.count, 5)
        serial.execute()
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testWait() {
        serial.cancel()
        let expect = expectation(description: "wating for WaitCommand complete")
        serial
            .wait(1)
            .completion({ command in
                XCTAssertEqual(self.serial.id, command.id)
                XCTAssertEqual(self.serial.count, 0)
                expect.fulfill()
            })
            .execute()
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testSuspend() {
        serial.cancel()
        serial
            .call({
                print("a")
            })
            .call({
                print("b")
                print("invoker suspend")
                self.serial.suspend()
                XCTAssertEqual(self.serial.isSuspended, true)
                self.serial.resume()
                XCTAssertEqual(self.serial.isSuspended, false)
            })
            .call({
                print("c")
            })
            .execute()
    }
    
    func testCancel() {
        serial.cancel()
        XCTAssertEqual(serial.count, 0)
        XCTAssertNil(serial.receiver)
        XCTAssertEqual(serial.isExcuting, false)
        XCTAssertEqual(serial.isSuspended, false)
    }
}
