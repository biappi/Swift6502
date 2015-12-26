//
//  CPU.swift
//  Swift6502
//
//  Created by Antonio Malara on 13/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

enum AddressingMode {
    case Implied
    case Immediate
    case ZeroPage
    case Accumulator
    case Absolute
    case ZeroPageX
    case ZeroPageY
    case AbsoluteX
    case AbsoluteY
    case IndexedX
    case IndexedY
    case Indirect
    case Relative
}

enum OpcodeValue {
    case Address(UInt16)
    case Accumulator(UInt8)
    case Implied
}

enum Instruction {
    case ADC
    case AND
    case ASL
    case BCC
    case BCS
    case BEQ
    case BIT
    case BMI
    case BNE
    case BPL
    case BRK
    case BVC
    case BVS
    case CLC
    case CLD
    case CLI
    case CLV
    case CMP
    case CPX
    case CPY
    case DEC
    case DEX
    case DEY
    case EOR
    case INC
    case INX
    case INY
    case JMP
    case JSR
    case LDA
    case LDX
    case LDY
    case LSR
    case NOP
    case ORA
    case PHA
    case PHP
    case PLA
    case PLP
    case ROL
    case ROR
    case RTI
    case RTS
    case SBC
    case SEC
    case SED
    case SEI
    case STA
    case STX
    case STY
    case TAX
    case TAY
    case TSX
    case TXA
    case TXS
    case TYA
    case ill
}

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

typealias OpcodeImplementation   = (OpcodeValue, CpuState, Memory) -> CpuState
typealias AddressingModeResolver = (CpuState, Memory) -> OpcodeValue

struct CpuState : Equatable {
    struct StatusRegister : OptionSetType {
        let rawValue : UInt8
        
        init(rawValue: UInt8) {
            self.rawValue = rawValue | 0b00100000
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
    var SP16 : UInt16 { get { return UInt16(self.SP) + 0x0100; } }
}

func CpuStep(cpuState: CpuState, memory: Memory) -> CpuState {
    let code     = Int(memory.byteAt(cpuState.PC))
    let opcode   = Opcodes[code]
    let value    = resolveOpcodeValue(opcode.1, cpu: cpuState, mem: memory)
    let newPC    = cpuState.PC + UInt16(instructionSize(opcode.1))
    let newState = cpuState.change(PC: newPC)
    let endState = execute(opcode.0, value: value, cpu: newState, mem: memory)
    
    return endState
}

class ArrayMemory : Memory {
    var ram : [UInt8] = [UInt8].init(count: 0x10000, repeatedValue: 0)
    
    func byteAt(address: Address) -> UInt8 {
        return ram[Int(address)]
    }
    
    func changeByteAt(address: Address, to: UInt8) {
        ram[Int(address)] = to
    }
}
