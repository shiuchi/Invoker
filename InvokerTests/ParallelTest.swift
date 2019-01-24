//
//  ParallelTest.swift
//  InvokerTests
//
//  Created by shiuchi on 2019/01/24.
//  Copyright © 2019 shiuchi. All rights reserved.
//

import XCTest

class ParallelTest: XCTestCase {

    let paralle = Parallel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAdd() {
        paralle.cancel()
        let expect = expectation(description: "wating for paralle command complete")
        paralle.add(CallbackCommand({
            print("a")
        }, params: ()))
        paralle.add(WaitCommand(1))
        
        
        paralle.call({
            print("b")
        })
        .wait(1)
        .completion({ _ in
            XCTAssertEqual(self.paralle.count, 0)
            expect.fulfill()
        })
        
        XCTAssertEqual(paralle.count, 4)
        paralle.execute()
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCancel() {
        paralle.cancel()
        XCTAssertEqual(paralle.count, 0)
        XCTAssertNil(paralle.receiver)
        XCTAssertEqual(paralle.isExcuting, false)
        XCTAssertEqual(paralle.isSuspended, false)
    }

}
