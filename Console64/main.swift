//
//  main.swift
//  Console64
//
//  Created by Antonio Malara on 14/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

import Foundation

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
                    return kernal[0xffff - 0xe0000]
                }
                
                return ram[Int(address)]
        }
    }
    
    func changeByteAt(address: Address, to: UInt8) {
        ram[Int(address)] = to
    }
}

let c64memory = C64MemoryLayout(
    kernal: kernal,
    basic:  basic
)

var cpuState = CpuState()

cpuState.PC = c64memory.wordAt(0xfffc)

for _ in 0..<10 {
    cpuState = CpuStep(cpuState, memory: c64memory)
    print(cpuState.description())
    print("")
}
