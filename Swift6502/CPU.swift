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
typealias AddressingModeResolver = (CpuState, Memory) -> OpcodeValue

struct AddressingMode {
    let name            : String
    let instructionSize : UInt16
    let resolve         : AddressingModeResolver
}

struct CpuState : Equatable {
    struct StatusRegister : OptionSetType {
        let rawValue : UInt8
        
        init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
        static let None = StatusRegister(rawValue: 0b00000000)
        static let C    = StatusRegister(rawValue: 0b00000001) // Carry
        static let Z    = StatusRegister(rawValue: 0b00000010) // Zero
        static let I    = StatusRegister(rawValue: 0b00000100) // Interrupt
        static let D    = StatusRegister(rawValue: 0b00001000) // Decimal
        static let B    = StatusRegister(rawValue: 0b00010000) // BRK
        static let V    = StatusRegister(rawValue: 0b01000000) // Overflow
        static let S    = StatusRegister(rawValue: 0b10000000) // Sign
    }
    
    var A  : UInt8          = 0x00
    var X  : UInt8          = 0x00
    var Y  : UInt8          = 0x00
    var SP : UInt8          = 0xFF
    var PC : UInt16         = 0x0000
    var SR : StatusRegister = StatusRegister(rawValue: 0x30)

    func change(
        A A : UInt8?  = nil,
        X   : UInt8?  = nil,
        Y   : UInt8?  = nil,
        SP  : UInt8?  = nil,
        PC  : UInt16? = nil,
        SR  : StatusRegister? = nil
    ) -> CpuState {
        return CpuState(
            A:  A  ?? self.A,
            X:  X  ?? self.X,
            Y:  Y  ?? self.Y,
            SP: SP ?? self.SP,
            PC: PC ?? self.PC,
            SR: SR ?? self.SR
        )
    }
}

func ==(lhs: CpuState, rhs: CpuState) -> Bool {
    return (
        lhs.A  == rhs.A &&
        lhs.X  == rhs.X &&
        lhs.Y  == rhs.Y &&
        lhs.SP == rhs.SP &&
        lhs.PC == rhs.PC &&
        lhs.SR.rawValue == rhs.SR.rawValue
    )
}


extension CpuState {
    var A16  : UInt16 { get { return UInt16(self.A);  } }
    var X16  : UInt16 { get { return UInt16(self.X);  } }
    var Y16  : UInt16 { get { return UInt16(self.Y);  } }
    var SP16 : UInt16 { get { return UInt16(self.SP); } }
}


func CpuStep(cpuState: CpuState , memory: Memory) -> CpuState {
    let code     = Int(memory.byteAt(cpuState.PC))
    let opcode   = Opcodes[code]
    let value    = opcode.1.resolve(cpuState, memory)
    var newState = opcode.2(value, c: cpuState, m: memory)
    newState.PC += opcode.1.instructionSize
    
    print(String(format:"Code %02x, \(opcode.0) \(opcode.1.name)", code))

    return newState
}
