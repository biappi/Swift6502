//
//  Opcodes.swift
//  Swift6502
//
//  Created by Antonio Malara on 14/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

func getValue(v: OpcodeValue, _ m: Memory) -> UInt8 {
    switch v {
    case .Address(let a):     return m.byteAt(a)
    case .Accumulator(let i): return i
    case .Implied:            return 0
    }
}

func setValue(v: OpcodeValue, _ n: UInt8, _ c: CpuState, _ m: Memory) -> CpuState {
    switch v {
    case .Address(let a): m.changeByteAt(a, to: n); return c
    case .Accumulator:    return c.change(A: n)
    case .Implied:        return c
    }
}

extension CpuState.StatusRegister {
    func setSZ(value : UInt8) -> CpuState.StatusRegister {
        var temp = self
        temp.remove([.Z, .S])
        
        if value == 0 { temp.insert(.Z) }
        if (value & 0x80) != 0 { temp.insert(.S) }
        
        return temp
    }
    
    func compare(v: UInt16, register: UInt8) -> CpuState.StatusRegister {
        var temp          = self
        let registerValue = Int8(bitPattern: register)
        let byteValue     = Int8(bitPattern: UInt8(truncatingBitPattern:v))
        
        temp.remove([.Z, .S, .C])
        
        if registerValue == byteValue {
            temp.insert([.C, .Z])
        }
        else if registerValue > byteValue {
            temp.insert(.C)
        }
        
        if (registerValue - byteValue) < 0 {
            temp.insert(.S)
        }
        
        return temp
    }
}

extension CpuState {
    func pushStackByte(v: UInt8, into memory: Memory) -> CpuState {
        memory.changeByteAt(self.SP16, to: v)
        return self.change(
            SP: self.SP - 1
        )
    }
    
    func popStackByte(memory: Memory) -> (UInt8, CpuState) {
        let cpuState = self.change(SP: self.SP + 1)
        
        return (
            memory.byteAt(cpuState.SP16),
            cpuState
        )
    }
    
    func pushStackWord(v: UInt16, into memory: Memory) -> CpuState {
        memory.changeWordAt(self.SP16 - 1, to: v)
        return self.change(
            SP: self.SP - 2
        )
    }

    func popStackWord(memory: Memory) -> (UInt16, CpuState) {
        let cpuState = self.change(SP: self.SP + 2)

        return (
            memory.wordAt(cpuState.SP16),
            cpuState
        )
    }
}

func ADC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func AND(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let f = c.A & getValue(v, m)
    return c.change(
        A: f,
        SR: c.SR.setSZ(f)
    )
}

func ASL(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func BCC(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        if c.SR.isSupersetOf(.C) {
            return c
        }
        else {
            return c.change(PC: a)
        }
    default:
        return c
    }
}

func BCS(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        if c.SR.isSupersetOf(.C) {
            return c.change(PC: a)
        }
        else {
            return c
        }
    default:
        return c
    }
}

func BEQ(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        if c.SR.isSupersetOf(.Z) {
            return c.change(PC: a)
        }
        else {
            return c
        }
    default:
        return c
    }
}

func BIT(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(v, m)
    
    var sr = c.SR
    sr.remove([.Z, .S, .V])
    
    if (c.A & v)  == 0 { sr.insert(.Z) }
    if (v & 0x80) != 0 { sr.insert(.S) }
    if (v & 0x40) != 0 { sr.insert(.V) }
    
    return c.change(SR: sr)
}

func BMI(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        if c.SR.isSupersetOf(.S) {
            return c.change(PC: a)
        }
        else {
            return c
        }
    default:
        return c
    }
}

func BNE(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        if c.SR.isSupersetOf(.Z) {
            return c
        }
        else {
            return c.change(PC: a)
        }
    default:
        return c
    }
}

func BPL(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        if c.SR.isSupersetOf(.S) {
            return c
        }
        else {
            return c.change(PC: a)
        }
    default:
        return c
    }
}

func BRK(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func BVC(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        if c.SR.isSupersetOf(.V) {
            return c
        }
        else {
            return c.change(PC: a)
        }
    default:
        return c
    }
}

func BVS(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        if c.SR.isSupersetOf(.V) {
            return c.change(PC: a)
        }
        else {
            return c
        }
    default:
        return c
    }
}

func CLC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    var x = c.SR
    x.remove(.C)
    return c.change(SR: x)
}

func CLD(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    var x = c.SR
    x.remove(.D)
    return c.change(SR: x)
}

func CLI(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    var x = c.SR
    x.remove(.I)
    return c.change(SR: x)
}

func CLV(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    var x = c.SR
    x.remove(.V)
    return c.change(SR: x)
}


func CMP(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(SR: c.SR.compare(UInt16(getValue(v, m)), register: c.A))
}

func CPX(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(SR: c.SR.compare(UInt16(getValue(v, m)), register: c.X))
}

func CPY(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(SR: c.SR.compare(UInt16(getValue(v, m)), register: c.Y))
}

func DEC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func DEX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = c.X &- 1
    return c.change(
        X:  v,
        SR: c.SR.setSZ(v)
    )
}

func DEY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = c.Y &- 1
    return c.change(
        Y:  v,
        SR: c.SR.setSZ(v)
    )
}

func EOR(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(v, m)
    let x = c.A ^ v
    
    return c.change(
        A: x,
        SR: c.SR.setSZ(x)
    )
}

func INC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func INX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = c.X &+ 1
    return c.change(
        X:  v,
        SR: c.SR.setSZ(v)
    )
}

func INY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = c.Y &+ 1
    return c.change(
        Y:  v,
        SR: c.SR.setSZ(v)
    )
}

func JMP(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a): return c.change(PC: a)
    default:              return c
    }
}

func JSR(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        let state = c.pushStackWord(c.PC - 1, into: m)
        return state.change(PC: a)
    default:
        return c
    }
}

func LDA(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(value, m)
    return c.change(
        A:  v,
        SR: c.SR.setSZ(v)
    )
}

func LDX(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(value, m)
    return c.change(
        X:  v,
        SR: c.SR.setSZ(v)
    )
}

func LDY(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(value, m)
    return c.change(
        Y:  v,
        SR: c.SR.setSZ(v)
    )
}

func LSR(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(value, m)
    let r = v >> 1
    
    var sr = c.SR
    sr.remove([.C])
    if (v & 0x1) != 0 {
        sr.insert(.C)
    }
    
    return setValue(value, r, c, m).change(SR:sr.setSZ(r))
}

func NOP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func ORA(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let f = c.A | getValue(v, m)
    return c.change(
        A: f,
        SR: c.SR.setSZ(f)
    )
}

func PHA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.pushStackByte(c.A, into: m)
}

func PHP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.pushStackByte(c.SR.rawValue, into: m)
}

func PLA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let (v, cpu) = c.popStackByte(m)
    return cpu.change(
        A: v,
        SR: c.SR.setSZ(v)
    )
}

func PLP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func ROL(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func ROR(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func RTI(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func RTS(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let (newPC, newState) = c.popStackWord(m)
    return newState.change(PC: newPC)
}

func SBC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func SEC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func SED(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func SEI(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(
        SR: c.SR.union(.I)
    )
}

func STA(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a):
        m.changeByteAt(a, to: c.A)
        return c
    default:
        return c
    }
}

func STX(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a): m.changeByteAt(a, to: c.X)
    default: return c
    }
    return c
}

func STY(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    switch v {
    case .Address(let a): m.changeByteAt(a, to: c.Y)
    default: return c
    }
    return c
}

func TAX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(
        X: c.A,
        SR: c.SR.setSZ(c.A)
    )
}

func TAY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(
        Y: c.A,
        SR: c.SR.setSZ(c.A)
    )
}

func TSX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(
        X: c.SP,
        SR: c.SR.setSZ(c.SP)
    )
}

func TXA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(
        A: c.X,
        SR: c.SR.setSZ(c.X)
    )
}

func TXS(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(
        SP: c.X
    )
}

func TYA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(
        A: c.Y,
        SR: c.SR.setSZ(c.Y)
    )
}

func ill(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
