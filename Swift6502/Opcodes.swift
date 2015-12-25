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

extension CpuState {
    func setSZ(value : UInt8) -> CpuState {
        var sr = self.SR
        sr.remove([.Z, .S])
        
        if value == 0 { sr.insert(.Z) }
        if (value & 0x80) != 0 { sr.insert(.S) }
        
        return self.change(SR: sr)
    }
    
    func compare(v: UInt16, register: UInt8) -> CpuState {
        var sr            = self.SR
        let registerValue = Int8(bitPattern: register)
        let byteValue     = Int8(bitPattern: UInt8(truncatingBitPattern:v))
        
        sr.remove([.Z, .S, .C])
        
        if registerValue == byteValue {
            sr.insert([.C, .Z])
        }
        else if registerValue > byteValue {
            sr.insert(.C)
        }
        
        if (registerValue - byteValue) < 0 {
            sr.insert(.S)
        }
        
        return self.change(SR: sr)
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
        let cpu1 = self.pushStackByte(UInt8(v >>  8), into: memory)
        let cpu2 = cpu1.pushStackByte(UInt8(v & 0xf), into: memory)
        return cpu2
    }

    func popStackWord(memory: Memory) -> (UInt16, CpuState) {
        let (lo, cpu1) = self.popStackByte(memory)
        let (hi, cpu2) = cpu1.popStackByte(memory)
        return (
            (UInt16(hi) << 8) + UInt16(lo),
            cpu2
        )
    }
}

func ADC(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v     = getValue(v, m)
    let carry = c.SR.contains(.C) ? 1 : 0

    if !c.SR.contains(.D) {
        let r16 = UInt16(v) +
                  UInt16(c.A) +
                  UInt16(carry)
        
        let r   = UInt8(truncatingBitPattern:r16)
        
        var sr  = c.SR
        sr.remove([.Z, .C, .V, .S])
        
        if ((~(c.A ^ v) & (c.A ^ r)) & 0x80) != 0 {
            sr.insert(.V)
        }
        
        if r16 > 0xff {
            sr.insert(.C)
        }
        
        if r  == 0x00 {
            sr.insert(.Z)
        }
        else if (r & 0x80) != 0 {
            sr.insert(.S)
        }
        
        return c.change(
            A: r,
            SR: sr
        )
    }
    else {
        let nibble0 : UInt8 = (v & 0xf) + (c.A & 0xf) + UInt8(carry)
        let adjust0 : UInt8 = nibble0 > 9 ? 6 : 0
        let carry0  : UInt8 = nibble0 > 9 ? 1 : 0
        
        let nibble1 : UInt8 = ((v >> 4) & 0xf) + ((c.A >> 4) & 0xf) + carry0
        let adjust1 : UInt8 = nibble1 > 9 ? 6 : 0
        let carry1  : UInt8 = nibble1 > 9 ? 1 : 0
        
        let aluresult       = ((nibble1 & 0xf) << 4) + (nibble0 & 0xf)
        let decimalresult   = (((nibble1 + adjust1) & 0xf) << 4) +
                              ((nibble0 + adjust0) & 0xf)
        
        var sr  = c.SR
        sr.remove([.Z, .C, .V, .S])
        
        if ((~(c.A ^ v) & (c.A ^ aluresult)) & 0x80) != 0 {
            sr.insert(.V)
        }
        
        if carry1 != 0 {
            sr.insert(.C)
        }
        
        if aluresult == 0x00 {
            sr.insert(.Z)
        }
        else if (aluresult & 0x80) != 0 {
            sr.insert(.S)
        }
        
        return c.change(
            A: decimalresult,
            SR: sr
        )
    }
}

func AND(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let f = c.A & getValue(v, m)
    return c.change(A: f).setSZ(f)
}

func ASL(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(value, m)
    let r = v << 1
    
    var sr = c.SR
    sr.remove([.C, .Z, .S])
    
    if r == 0 {
        sr.insert(.Z)
    }
    else if (r & 0x80) != 0 {
        sr.insert(.S)
    }
    
    if (v & 0x80) != 0 {
        sr.insert(.C)
    }
    
    return setValue(value, r, c, m).change(SR: sr)
}

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

func BRK(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let cpu1 = c.pushStackWord(c.PC + 1, into: m)
    var sr = cpu1.SR
    sr.insert(.B)
    let cpu2 = cpu1.pushStackByte(sr.rawValue, into: m)
    sr.insert(.I)
    return cpu2.change(PC: m.wordAt(0xfffe), SR: sr)
}

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
    return c.compare(UInt16(getValue(v, m)), register: c.A)
}

func CPX(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.compare(UInt16(getValue(v, m)), register: c.X)
}

func CPY(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.compare(UInt16(getValue(v, m)), register: c.Y)
}

func DEC(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = (getValue(value, m) &- 1)
    return setValue(value, v, c, m).setSZ(v)
}

func DEX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = c.X &- 1
    return c.change(X: v).setSZ(v)
}

func DEY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = c.Y &- 1
    return c.change(Y: v).setSZ(v)
}

func EOR(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(v, m)
    let x = c.A ^ v
    
    return c.change(A: x).setSZ(x)
}

func INC(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(value, m) &+ 1
    return setValue(value, v, c, m).setSZ(v)
}

func INX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = c.X &+ 1
    return c.change(X: v).setSZ(v)
}

func INY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = c.Y &+ 1
    return c.change(Y: v).setSZ(v)
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
    return c.change(A: v).setSZ(v)
}

func LDX(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(value, m)
    return c.change(X: v).setSZ(v)
}

func LDY(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(value, m)
    return c.change(Y: v).setSZ(v)
}

func LSR(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v = getValue(value, m)
    let r = v >> 1
    
    var sr = c.SR
    sr.remove([.C])
    if (v & 0x1) != 0 {
        sr.insert(.C)
    }
    
    return setValue(value, r, c, m).change(SR: sr).setSZ(r)
}

func NOP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func ORA(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let f = c.A | getValue(v, m)
    return c.change(A: f).setSZ(f)
}

func PHA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.pushStackByte(c.A, into: m)
}

func PHP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.pushStackByte(c.SR.rawValue, into: m)
}

func PLA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let (v, cpu) = c.popStackByte(m)
    return cpu.change(A: v).setSZ(v)
}

func PLP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let (v, cpu) = c.popStackByte(m)
    return cpu.change(
        SR: CpuState.StatusRegister(rawValue: v)
    )
}

func ROL(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let value  = getValue(v, m)
    let carry  = c.SR.contains(.C) ? UInt8(1) : UInt8(0)
    let result = (value << 1) | carry
    
    var sr     = c.SR
    if (value & 0x80) != 0 { sr.insert(.C) } else { sr.remove(.C) }
    
    return setValue(v, result, c, m).change(SR: sr).setSZ(result)
}

func ROR(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let value  = getValue(v, m)
    let carry  = c.SR.contains(.C) ? UInt8(0x80) : UInt8(0)
    let result = (value >> 1) | carry
    
    var sr     = c.SR
    if (value & 0x01) != 0 { sr.insert(.C) } else { sr.remove(.C) }
    
    return setValue(v, result, c, m).change(SR: sr).setSZ(result)
}

func RTI(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let (SR, cpu1) = c.popStackByte(m)
    let (PC, cpu2) = cpu1.popStackWord(m)
    
    var sr = CpuState.StatusRegister(rawValue:SR)
    sr.insert(.B)
    return cpu2.change(PC: PC, SR:sr)
}

func RTS(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let (newPC, newState) = c.popStackWord(m)
    return newState.change(PC: newPC &+ 1)
}

func SBC(v: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    let v     = ~getValue(v, m)
    let carry = c.SR.contains(.C) ? 1 : 0
    let r16   = UInt16(v) +
                UInt16(c.A) +
                UInt16(carry)

    if !c.SR.contains(.D) {
        let r   = UInt8(truncatingBitPattern:r16)
        
        var sr  = c.SR
        sr.remove([.Z, .C, .V, .S])
        
        if ((c.A ^ ~v) & (c.A ^ r) & 0x80) != 0 {
            sr.insert(.V)
        }
        
        if r16 > 0xff {
            sr.insert(.C)
        }
        
        if r  == 0x00 {
            sr.insert(.Z)
        }
        else if (r & 0x80) != 0 {
            sr.insert(.S)
        }
        
        return c.change(
            A: r,
            SR: sr
        )
    }
    else {
        let nibble0 : UInt8 = (v & 0xf) + (c.A & 0xf) + UInt8(carry)
        let adjust0 : UInt8 = nibble0 <= 0xf ? 10 : 0
        let carry0  : UInt8 = nibble0 <= 0xf ?  0 : 1
        
        let nibble1 : UInt8 = ((v >> 4) & 0xf) + ((c.A >> 4) & 0xf) + carry0
        let adjust1 : UInt8 = nibble1 <= 0xf ? 10 : 0
        
        let aluresult       = UInt8(truncatingBitPattern:r16)
        let decimalresult   = (((nibble1 + adjust1) & 0xf) << 4) +
                               ((nibble0 + adjust0) & 0xf)
        
        var sr  = c.SR
        sr.remove([.Z, .C, .V, .S])
        
        if ((c.A ^ ~v) & (c.A ^ aluresult) & 0x80) != 0 {
            sr.insert(.V)
        }
        
        if r16 > 0xff {
            sr.insert(.C)
        }
        
        if aluresult == 0x00 {
            sr.insert(.Z)
        }
        else if (aluresult & 0x80) != 0 {
            sr.insert(.S)
        }
        
        return c.change(
            A: decimalresult,
            SR: sr
        )
    }
}

func SEC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(SR:c.SR.union(.C))
}

func SED(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(SR:c.SR.union(.D))
}

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
    return c.change(X: c.A).setSZ(c.A)
}

func TAY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(Y: c.A).setSZ(c.A)
}

func TSX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(X: c.SP).setSZ(c.SP)
}

func TXA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(A: c.X).setSZ(c.X)
}

func TXS(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(SP: c.X)
}

func TYA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(A: c.Y).setSZ(c.Y)
}

func ill(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
