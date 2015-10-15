//
//  Opcodes.swift
//  Swift6502
//
//  Created by Antonio Malara on 14/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//


func ADC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func AND(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func ASL(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BCC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BCS(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BEQ(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BIT(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BMI(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BNE(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BPL(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BRK(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BVC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func BVS(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func CLC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func CLD(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func CLI(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func CLV(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func CMP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func CPX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func CPY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func DEC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func DEX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func DEY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func EOR(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func INC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func INX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func INY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func JMP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func JSR(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func LDA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

extension CpuState.StatusRegister {
    func setSZ(value : Int8) -> CpuState.StatusRegister {
        var temp = self
        
        if   value == 0 { temp.insert(.Z) }
        else            { temp.remove(.Z) }
        
        if   value  < 0 { temp.insert(.S) }
        else            { temp.remove(.S) }
        
        return temp
    }
}

func LDX(value: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(
        X:  UInt8(value),
        SR: c.SR.setSZ(Int8(bitPattern:UInt8(value)))
    )
}

func LDY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func LSR(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func NOP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func ORA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func PHA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func PHP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func PLA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func PLP(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func ROL(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func ROR(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func RTI(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func RTS(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func SBC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func SEC(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func SED(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func SEI(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState {
    return c.change(
        SR: c.SR.union(.I)
    )
}

func STA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func STX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func STY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func TAX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func TAY(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func TSX(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func TXA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func TXS(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
func TYA(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }

func ill(_: OpcodeValue, c: CpuState, m: Memory) -> CpuState { return c }
