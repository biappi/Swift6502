//
//  Swift6502Tests.swift
//  Swift6502Tests
//
//  Created by Antonio Malara on 12/26/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

import XCTest

class OpcodeTestBase: XCTestCase {
    func do_the_test(precondition: TestState, _ postcondition: TestState) {
        let mem  = ArrayMemory()
        for (addr, value) in precondition.mem {
            mem.changeByteAt(addr, to: value)
        }
        
        let test = CpuStep(precondition.cpu, memory: mem)
        
        var failedMem   = false
        var errorString = ""
        
        for (addr, expected) in postcondition.mem {
            if mem.byteAt(addr) == expected {
                errorString += "√ \(addr): \(expected)\n"
            }
            else {
                errorString += "X \(addr): \(mem.byteAt(addr)) != expected \(expected)\n"
                failedMem = true
            }
        }
        
        XCTAssert(
            test == postcondition.cpu,
            "cpu states do not match:\ngot:\n\(test.description())\nexpected:\n\(postcondition.cpu)"
        )
        
        XCTAssert(!failedMem, errorString)
    }    
}
