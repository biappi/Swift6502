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

for correctState in c64boottrace {
    let correct = cpuState == correctState

    print(correctState.description())
    print(cpuState.description())
    print("")
    
    if correct {
        print ("√\n")
    }
    else {
        print ("X")
        break
    }
    
    cpuState = CpuStep(cpuState, memory: c64memory)
}

