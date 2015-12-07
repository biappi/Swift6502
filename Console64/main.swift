//
//  main.swift
//  Console64
//
//  Created by Antonio Malara on 14/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

import Foundation

class ArrayMemory : Memory {
    var ram : [UInt8] = [UInt8].init(count: 0x10000, repeatedValue: 0)
    
    func byteAt(address: Address) -> UInt8 {
            return ram[Int(address)]
    }
    
    func changeByteAt(address: Address, to: UInt8) {
        ram[Int(address)] = to
    }
}

class C64MemoryLayout : Memory {
    let kernal : [UInt8]
    let basic  : [UInt8]
    
    var ram    : [UInt8]
    
    init (kernal : [UInt8], basic : [UInt8]) {
        self.kernal = kernal
        self.basic  = basic
        self.ram    = [UInt8].init(count: 0x10000, repeatedValue: 0)
    }
    
    func byteAt(address: Address) -> UInt8 {
        switch address {
            case 0xe000..<0xffff:
                return kernal[Int(address - 0xe000)]
            case 0xa000...0xbfff:
                return basic[Int(address - 0xa000)]
            case 0xd012:
                 // I/O address, current raster line
                return 0
            default:
                if address == 0xffff {
                    // swift bug, http://www.openradar.appspot.com/23101392
                    return kernal[0xffff - 0xe000]
                }
                
                return ram[Int(address)]
        }
    }
    
    func changeByteAt(address: Address, to: UInt8) {
        ram[Int(address)] = to
    }
}

var failed = 0
var success = 0

for test in tests_6502 {
    var ok = true
    
    let mem = ArrayMemory()
    
    for (addr, value) in test.pre.mem {
        mem.changeByteAt(addr, to: value)
    }
    
    let state = CpuStep(test.pre.cpu, memory: mem)
    
    print("Test \(test.name)")
    
    if state != test.post.cpu {
        print("Got state:")
        print(state.description())
        print("Expected:")
        print(test.post.cpu.description())
        ok = false
    }
    
    for (addr, value) in test.post.mem {
        if mem.byteAt(addr) != value {
            print("Failed, address \(addr)")
            print("Computed \(mem.byteAt(addr))")
            print("Expected \(value)")
            ok = false
        }
    }
    
    if (ok) {
        print("Succeded\n\n")
        success++
    }
    else {
        print("Failed\n\n")
        failed++
    }
}

print ("success: \(success) fail: \(failed)")

exit(0)

let c64boottrace = [
    CpuState(A: 0x00, X: 0x00, Y: 0x00, SP: 0xff, PC: 0xfce2, SR: CpuState.StatusRegister(rawValue: 0x30)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xff, PC: 0xfce4, SR: CpuState.StatusRegister(rawValue: 0xb0)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xff, PC: 0xfce5, SR: CpuState.StatusRegister(rawValue: 0xb4)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xff, PC: 0xfce6, SR: CpuState.StatusRegister(rawValue: 0xb4)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xff, PC: 0xfce7, SR: CpuState.StatusRegister(rawValue: 0xb4)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfd02, SR: CpuState.StatusRegister(rawValue: 0xb4)),
    CpuState(A: 0x00, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfd04, SR: CpuState.StatusRegister(rawValue: 0x34)),
    CpuState(A: 0x30, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfd07, SR: CpuState.StatusRegister(rawValue: 0x34)),
    CpuState(A: 0x30, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfd0a, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x30, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfd0f, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x30, X: 0x05, Y: 0x00, SP: 0xff, PC: 0xfcea, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x30, X: 0x05, Y: 0x00, SP: 0xff, PC: 0xfcef, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x30, X: 0x05, Y: 0x00, SP: 0xff, PC: 0xfcf2, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x30, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfda3, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x7f, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfda5, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x7f, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfda8, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x7f, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfdab, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x7f, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfdae, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x08, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfdb0, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x08, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfdb3, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x08, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfdb6, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x08, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfdb9, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x08, X: 0x05, Y: 0x00, SP: 0xfd, PC: 0xfdbc, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x08, X: 0x00, Y: 0x00, SP: 0xfd, PC: 0xfdbe, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x08, X: 0x00, Y: 0x00, SP: 0xfd, PC: 0xfdc1, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x08, X: 0x00, Y: 0x00, SP: 0xfd, PC: 0xfdc4, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x08, X: 0x00, Y: 0x00, SP: 0xfd, PC: 0xfdc7, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x08, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdc8, SR: CpuState.StatusRegister(rawValue: 0xb5)),
    CpuState(A: 0x08, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdcb, SR: CpuState.StatusRegister(rawValue: 0xb5)),
    CpuState(A: 0x07, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdcd, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x07, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdd0, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x3f, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdd2, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x3f, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdd5, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0xe7, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdd7, SR: CpuState.StatusRegister(rawValue: 0xb5)),
    CpuState(A: 0xe7, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdd9, SR: CpuState.StatusRegister(rawValue: 0xb5)),
    CpuState(A: 0x2f, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfddb, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x2f, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfddd, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfde0, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdec, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x95, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdee, SR: CpuState.StatusRegister(rawValue: 0xb5)),
    CpuState(A: 0x95, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdf1, SR: CpuState.StatusRegister(rawValue: 0xb5)),
    CpuState(A: 0x42, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdf3, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x42, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfdf6, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x42, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xff6e, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x81, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xff70, SR: CpuState.StatusRegister(rawValue: 0xb5)),
    CpuState(A: 0x81, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xff73, SR: CpuState.StatusRegister(rawValue: 0xb5)),
    CpuState(A: 0x08, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xff76, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xff78, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x11, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xff7a, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x11, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xff7d, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x11, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xee8e, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x07, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xee91, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x17, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xee93, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x17, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xee96, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x17, X: 0xff, Y: 0x00, SP: 0xff, PC: 0xfcf5, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x17, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfd50, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfd52, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfd53, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfd56, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfd59, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x00, X: 0xff, Y: 0x00, SP: 0xfd, PC: 0xfd5c, SR: CpuState.StatusRegister(rawValue: 0x37)),
    CpuState(A: 0x00, X: 0xff, Y: 0x01, SP: 0xfd, PC: 0xfd5d, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x01, SP: 0xfd, PC: 0xfd53, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x01, SP: 0xfd, PC: 0xfd56, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x01, SP: 0xfd, PC: 0xfd59, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x01, SP: 0xfd, PC: 0xfd5c, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x02, SP: 0xfd, PC: 0xfd5d, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x02, SP: 0xfd, PC: 0xfd53, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x02, SP: 0xfd, PC: 0xfd56, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x02, SP: 0xfd, PC: 0xfd59, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x02, SP: 0xfd, PC: 0xfd5c, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x03, SP: 0xfd, PC: 0xfd5d, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x03, SP: 0xfd, PC: 0xfd53, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x03, SP: 0xfd, PC: 0xfd56, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x03, SP: 0xfd, PC: 0xfd59, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x03, SP: 0xfd, PC: 0xfd5c, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x04, SP: 0xfd, PC: 0xfd5d, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x04, SP: 0xfd, PC: 0xfd53, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x04, SP: 0xfd, PC: 0xfd56, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x04, SP: 0xfd, PC: 0xfd59, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x04, SP: 0xfd, PC: 0xfd5c, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x05, SP: 0xfd, PC: 0xfd5d, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x05, SP: 0xfd, PC: 0xfd53, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x05, SP: 0xfd, PC: 0xfd56, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x05, SP: 0xfd, PC: 0xfd59, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x05, SP: 0xfd, PC: 0xfd5c, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x06, SP: 0xfd, PC: 0xfd5d, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x06, SP: 0xfd, PC: 0xfd53, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x06, SP: 0xfd, PC: 0xfd56, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x06, SP: 0xfd, PC: 0xfd59, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x06, SP: 0xfd, PC: 0xfd5c, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x07, SP: 0xfd, PC: 0xfd5d, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x07, SP: 0xfd, PC: 0xfd53, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x07, SP: 0xfd, PC: 0xfd56, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x07, SP: 0xfd, PC: 0xfd59, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x07, SP: 0xfd, PC: 0xfd5c, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x08, SP: 0xfd, PC: 0xfd5d, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x08, SP: 0xfd, PC: 0xfd53, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x08, SP: 0xfd, PC: 0xfd56, SR: CpuState.StatusRegister(rawValue: 0x35)),
    CpuState(A: 0x00, X: 0xff, Y: 0x08, SP: 0xfd, PC: 0xfd59, SR: CpuState.StatusRegister(rawValue: 0x35)),
]

let c64memory = C64MemoryLayout(
    kernal: kernal,
    basic:  basic
)

var cpuState = CpuState()

cpuState.PC = c64memory.wordAt(0xfffc)

for (i, correctState) in c64boottrace.enumerate() {
    let correct = cpuState == correctState
    
    if correct {
        print ("√\n")
    }
    else {
        print("Expected:")
        print(correctState.description())
        print("Got:")
        print(cpuState.description())
        print("")

        print ("X")
        break
    }
    
    let pc       = cpuState.PC
    let code     = Int(c64memory.byteAt(pc))
    let opcode   = Opcodes[code]
    let pcString = String(format: "%2d [%04x]", i, pc)
    
    print(String(format:"\(pcString) Code %02x, \(opcode.0) \(opcode.1.name)", code))

    cpuState = CpuStep(cpuState, memory: c64memory)
}

