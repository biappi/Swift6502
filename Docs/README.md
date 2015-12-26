Documentation
=============

This folder contains a bit of documentation about the 6502, in machine readable format
since it is useful for both humans and machines.

- `opcodes.json` is an array from opcode to a tuple of instruction mnemonic and
   addressing mode,

- `addressign_modes.json` is a dictionary keyed on addressing mode, in the same format
  as `opcodes.json` with instruction size in bytes and a sprintf-style format string
  to format the operand in the standard asm syntax.
