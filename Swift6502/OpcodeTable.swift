//
//  OpcodeTable.swift
//  Swift6502
//
//  Created by Antonio Malara on 14/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

let Opcodes : [(Instruction, AddressingMode)] = [
    (.BRK, .Implied),
    (.ORA, .IndexedX),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ORA, .ZeroPage),
    (.ASL, .ZeroPage),
    (.ill, .Implied),
    (.PHP, .Implied),
    (.ORA, .Immediate),
    (.ASL, .Accumulator),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ORA, .Absolute),
    (.ASL, .Absolute),
    (.ill, .Implied),
    (.BPL, .Relative),
    (.ORA, .IndexedY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ORA, .ZeroPageX),
    (.ASL, .ZeroPageX),
    (.ill, .Implied),
    (.CLC, .Implied),
    (.ORA, .AbsoluteY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ORA, .AbsoluteX),
    (.ASL, .AbsoluteX),
    (.ill, .Implied),
    (.JSR, .Absolute),
    (.AND, .IndexedX),
    (.ill, .Implied),
    (.ill, .Implied),
    (.BIT, .ZeroPage),
    (.AND, .ZeroPage),
    (.ROL, .ZeroPage),
    (.ill, .Implied),
    (.PLP, .Implied),
    (.AND, .Immediate),
    (.ROL, .Accumulator),
    (.ill, .Implied),
    (.BIT, .Absolute),
    (.AND, .Absolute),
    (.ROL, .Absolute),
    (.ill, .Implied),
    (.BMI, .Relative),
    (.AND, .IndexedY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.AND, .ZeroPageX),
    (.ROL, .ZeroPageX),
    (.ill, .Implied),
    (.SEC, .Implied),
    (.AND, .AbsoluteY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.AND, .AbsoluteX),
    (.ROL, .AbsoluteX),
    (.ill, .Implied),
    (.RTI, .Implied),
    (.EOR, .IndexedX),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.EOR, .ZeroPage),
    (.LSR, .ZeroPage),
    (.ill, .Implied),
    (.PHA, .Implied),
    (.EOR, .Immediate),
    (.LSR, .Accumulator),
    (.ill, .Implied),
    (.JMP, .Absolute),
    (.EOR, .Absolute),
    (.LSR, .Absolute),
    (.ill, .Implied),
    (.BVC, .Relative),
    (.EOR, .IndexedY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.EOR, .ZeroPageX),
    (.LSR, .ZeroPageX),
    (.ill, .Implied),
    (.CLI, .Implied),
    (.EOR, .AbsoluteY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.EOR, .AbsoluteX),
    (.LSR, .AbsoluteX),
    (.ill, .Implied),
    (.RTS, .Implied),
    (.ADC, .IndexedX),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ADC, .ZeroPage),
    (.ROR, .ZeroPage),
    (.ill, .Implied),
    (.PLA, .Implied),
    (.ADC, .Immediate),
    (.ROR, .Accumulator),
    (.ill, .Implied),
    (.JMP, .Indirect),
    (.ADC, .Absolute),
    (.ROR, .Absolute),
    (.ill, .Implied),
    (.BVS, .Relative),
    (.ADC, .IndexedY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ADC, .ZeroPageX),
    (.ROR, .ZeroPageX),
    (.ill, .Implied),
    (.SEI, .Implied),
    (.ADC, .AbsoluteY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ADC, .AbsoluteX),
    (.ROR, .AbsoluteX),
    (.ill, .Implied),
    (.ill, .Implied),
    (.STA, .IndexedX),
    (.ill, .Implied),
    (.ill, .Implied),
    (.STY, .ZeroPage),
    (.STA, .ZeroPage),
    (.STX, .ZeroPage),
    (.ill, .Implied),
    (.DEY, .Implied),
    (.ill, .Implied),
    (.TXA, .Implied),
    (.ill, .Implied),
    (.STY, .Absolute),
    (.STA, .Absolute),
    (.STX, .Absolute),
    (.ill, .Implied),
    (.BCC, .Relative),
    (.STA, .IndexedY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.STY, .ZeroPageX),
    (.STA, .ZeroPageX),
    (.STX, .ZeroPageY),
    (.ill, .Implied),
    (.TYA, .Implied),
    (.STA, .AbsoluteY),
    (.TXS, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.STA, .AbsoluteX),
    (.ill, .Implied),
    (.ill, .Implied),
    (.LDY, .Immediate),
    (.LDA, .IndexedX),
    (.LDX, .Immediate),
    (.ill, .Implied),
    (.LDY, .ZeroPage),
    (.LDA, .ZeroPage),
    (.LDX, .ZeroPage),
    (.ill, .Implied),
    (.TAY, .Implied),
    (.LDA, .Immediate),
    (.TAX, .Implied),
    (.ill, .Implied),
    (.LDY, .Absolute),
    (.LDA, .Absolute),
    (.LDX, .Absolute),
    (.ill, .Implied),
    (.BCS, .Relative),
    (.LDA, .IndexedY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.LDY, .ZeroPageX),
    (.LDA, .ZeroPageX),
    (.LDX, .ZeroPageY),
    (.ill, .Implied),
    (.CLV, .Implied),
    (.LDA, .AbsoluteY),
    (.TSX, .Implied),
    (.ill, .Implied),
    (.LDY, .AbsoluteX),
    (.LDA, .AbsoluteX),
    (.LDX, .AbsoluteY),
    (.ill, .Implied),
    (.CPY, .Immediate),
    (.CMP, .IndexedX),
    (.ill, .Implied),
    (.ill, .Implied),
    (.CPY, .ZeroPage),
    (.CMP, .ZeroPage),
    (.DEC, .ZeroPage),
    (.ill, .Implied),
    (.INY, .Implied),
    (.CMP, .Immediate),
    (.DEX, .Implied),
    (.ill, .Implied),
    (.CPY, .Absolute),
    (.CMP, .Absolute),
    (.DEC, .Absolute),
    (.ill, .Implied),
    (.BNE, .Relative),
    (.CMP, .IndexedY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.CMP, .ZeroPageX),
    (.DEC, .ZeroPageX),
    (.ill, .Implied),
    (.CLD, .Implied),
    (.CMP, .AbsoluteY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.CMP, .AbsoluteX),
    (.DEC, .AbsoluteX),
    (.ill, .Implied),
    (.CPX, .Immediate),
    (.SBC, .IndexedX),
    (.ill, .Implied),
    (.ill, .Implied),
    (.CPX, .ZeroPage),
    (.SBC, .ZeroPage),
    (.INC, .ZeroPage),
    (.ill, .Implied),
    (.INX, .Implied),
    (.SBC, .Immediate),
    (.NOP, .Implied),
    (.ill, .Implied),
    (.CPX, .Absolute),
    (.SBC, .Absolute),
    (.INC, .Absolute),
    (.ill, .Implied),
    (.BEQ, .Relative),
    (.SBC, .IndexedY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.SBC, .ZeroPageX),
    (.INC, .ZeroPageX),
    (.ill, .Implied),
    (.SED, .Implied),
    (.SBC, .AbsoluteY),
    (.ill, .Implied),
    (.ill, .Implied),
    (.ill, .Implied),
    (.SBC, .AbsoluteX),
    (.INC, .AbsoluteX),
    (.ill, .Implied),
]

func execute(
    inst: Instruction,
    value: OpcodeValue,
    cpu: CpuState,
    mem: Memory
) -> CpuState
{
    switch inst {
    case .ADC: return ADC(value, c: cpu, m: mem)
    case .AND: return AND(value, c: cpu, m: mem)
    case .ASL: return ASL(value, c: cpu, m: mem)
    case .BCC: return BCC(value, c: cpu, m: mem)
    case .BCS: return BCS(value, c: cpu, m: mem)
    case .BEQ: return BEQ(value, c: cpu, m: mem)
    case .BIT: return BIT(value, c: cpu, m: mem)
    case .BMI: return BMI(value, c: cpu, m: mem)
    case .BNE: return BNE(value, c: cpu, m: mem)
    case .BPL: return BPL(value, c: cpu, m: mem)
    case .BRK: return BRK(value, c: cpu, m: mem)
    case .BVC: return BVC(value, c: cpu, m: mem)
    case .BVS: return BVS(value, c: cpu, m: mem)
    case .CLC: return CLC(value, c: cpu, m: mem)
    case .CLD: return CLD(value, c: cpu, m: mem)
    case .CLI: return CLI(value, c: cpu, m: mem)
    case .CLV: return CLV(value, c: cpu, m: mem)
    case .CMP: return CMP(value, c: cpu, m: mem)
    case .CPX: return CPX(value, c: cpu, m: mem)
    case .CPY: return CPY(value, c: cpu, m: mem)
    case .DEC: return DEC(value, c: cpu, m: mem)
    case .DEX: return DEX(value, c: cpu, m: mem)
    case .DEY: return DEY(value, c: cpu, m: mem)
    case .EOR: return EOR(value, c: cpu, m: mem)
    case .INC: return INC(value, c: cpu, m: mem)
    case .INX: return INX(value, c: cpu, m: mem)
    case .INY: return INY(value, c: cpu, m: mem)
    case .JMP: return JMP(value, c: cpu, m: mem)
    case .JSR: return JSR(value, c: cpu, m: mem)
    case .LDA: return LDA(value, c: cpu, m: mem)
    case .LDX: return LDX(value, c: cpu, m: mem)
    case .LDY: return LDY(value, c: cpu, m: mem)
    case .LSR: return LSR(value, c: cpu, m: mem)
    case .NOP: return NOP(value, c: cpu, m: mem)
    case .ORA: return ORA(value, c: cpu, m: mem)
    case .PHA: return PHA(value, c: cpu, m: mem)
    case .PHP: return PHP(value, c: cpu, m: mem)
    case .PLA: return PLA(value, c: cpu, m: mem)
    case .PLP: return PLP(value, c: cpu, m: mem)
    case .ROL: return ROL(value, c: cpu, m: mem)
    case .ROR: return ROR(value, c: cpu, m: mem)
    case .RTI: return RTI(value, c: cpu, m: mem)
    case .RTS: return RTS(value, c: cpu, m: mem)
    case .SBC: return SBC(value, c: cpu, m: mem)
    case .SEC: return SEC(value, c: cpu, m: mem)
    case .SED: return SED(value, c: cpu, m: mem)
    case .SEI: return SEI(value, c: cpu, m: mem)
    case .STA: return STA(value, c: cpu, m: mem)
    case .STX: return STX(value, c: cpu, m: mem)
    case .STY: return STY(value, c: cpu, m: mem)
    case .TAX: return TAX(value, c: cpu, m: mem)
    case .TAY: return TAY(value, c: cpu, m: mem)
    case .TSX: return TSX(value, c: cpu, m: mem)
    case .TXA: return TXA(value, c: cpu, m: mem)
    case .TXS: return TXS(value, c: cpu, m: mem)
    case .TYA: return TYA(value, c: cpu, m: mem)
    
    case .ill: return NOP(value, c: cpu, m: mem)
    }
}