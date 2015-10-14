//
//  CPU.swift
//  Swift6502
//
//  Created by Antonio Malara on 13/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

import Foundation

typealias Address = UInt16

protocol Memory {
    func byteAt(address: Address) -> UInt8
    func changeByteAt(address: Address, to: UInt8)
}

extension Memory {
    func wordAt(address: Address) -> UInt16 {
        let low : UInt16 = UInt16(byteAt(address))
        let hi  : UInt16 = UInt16(byteAt(address + 1))
        return hi << 8 + low
    }
    
    func changeWordAt(address: Address, to: UInt16) {
        let lo : UInt8 = UInt8(to & 0xFF)
        let hi : UInt8 = UInt8(to >> 8)
        
        self.changeByteAt(address,     to: lo)
        self.changeByteAt(address + 1, to: hi)
    }
}

typealias OpcodeValue            = UInt16
typealias OpcodeImplementation   = (OpcodeValue, CpuState, Memory) -> (CpuState)
typealias AddressingModeResolver = (cpuState: CpuState, memory: Memory) -> OpcodeValue

struct AddressingMode {
    let name            : String
    let instructionSize : UInt16
    let resolve         : AddressingModeResolver
}

struct CpuState {
    struct StatusRegister : OptionSetType {
        let rawValue : UInt8
        
        init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
        static let None = StatusRegister(rawValue: 0b00000000)
        static let C    = StatusRegister(rawValue: 0b00000001)
        static let Z    = StatusRegister(rawValue: 0b00000010)
        static let I    = StatusRegister(rawValue: 0b00000100)
        static let D    = StatusRegister(rawValue: 0b00001000)
        static let B    = StatusRegister(rawValue: 0b00010000)
        static let V    = StatusRegister(rawValue: 0b01000000)
        static let F    = StatusRegister(rawValue: 0b10000000)
    }
    
    var A  : UInt8          = 0x00
    var X  : UInt8          = 0x00
    var Y  : UInt8          = 0x00
    var SP : UInt8          = 0x00
    var PC : UInt16         = 0x0000
    var SR : StatusRegister = .None
}

func CpuStep(cpuState: CpuState , memory: Memory) -> CpuState {
    let code     = Int(memory.byteAt(cpuState.PC))
    let opcode   = Opcodes[code]
    let value    = opcode.1.resolve(cpuState: cpuState, memory: memory)
    var newState = opcode.2(value, c: cpuState, m: memory)
    newState.PC += opcode.1.instructionSize
    
    print(String(format:"Code %02x, \(opcode.0) \(opcode.1.name)", code))

    return newState
}
