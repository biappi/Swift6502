from py65.tests.devices.test_mpu6502 import MPUTests, Common6502Tests
from py65.devices.mpu6502 import MPU

import json

class Memory(object):
    def __init__(self):
        self.mem = {}

    def __getitem__(self, item):
        return self.mem[item]

    def __setitem__(self, item, value):
        if isinstance(item, slice):
            indexes = range(*item.indices(0x10000))
            for i, v in zip(indexes, value):
                self.__setitem__(i, v)
        else:
            self.mem[item] = value

class CPUStepped(Exception): pass

class CPU(object):
    # processor flags
    NEGATIVE = 128
    OVERFLOW = 64
    UNUSED = 32
    BREAK = 16  # there is no actual BREAK flag but this indicates BREAK
    DECIMAL = 8
    INTERRUPT = 4
    ZERO = 2
    CARRY = 1

    real = ('memory', 'regs')

    def __init__(self):
        self.memory = Memory()
        self.regs   = {
            'pc': 0,
            'a' : 0,
            'x' : 0,
            'y' : 0,
            'p' : self.BREAK | self.UNUSED,
        }

    def __setattr__(self, x, v):
        if x in self.real:
            self.__dict__[x] = v
            return

        self.regs[x] = v

    def __getattr__(self, x):
        return self.regs[x]

    def step(self):
        x = CPUStepped()
        x.cpu = self
        raise x

class TestHarness(Common6502Tests):
    def _make_mpu(self):
        return CPU()

def get_preconditions(func):
    try:
        func()
        raise Exception()
    except CPUStepped as c:
        return {
            'regs': c.cpu.regs,
            'mem': c.cpu.memory.mem,
        }

class ChangeTrackingMemory(object):
    def __init__(self, initial=None):
        self.mem = {}
        if initial:
            self.mem.update(initial)

    def __getitem__(self, x):
        return self.mem[x]

    def __setitem__(self, x, y):
        self.mem[x] = y
        

def get_postconditions(pre):
    cpu = MPU()
    cpu.memory = ChangeTrackingMemory(pre['mem'])
    for r, v in pre['regs'].iteritems():
        setattr(cpu, r, v)
    cpu.step()
    return {
        'regs': {r: getattr(cpu, r) for r in pre['regs'].keys()},
        'mem': cpu.memory.mem,
    }

if __name__ == '__main__':
    disabled  = (
        'test_adc_bcd_off_absolute_carry_clear_in_accumulator_zeroes',
        'test_decorated_addressing_modes_are_valid',
        'test_reset_sets_registers_to_initial_states',
    )

    harness   = TestHarness()
    testnames = [i for i in dir(harness) if i.startswith('test_') and not i in disabled]
    methods   = [getattr(harness, i) for i in testnames]
    preconds  = [get_preconditions(i) for i in methods]
    postconds = [get_postconditions(i) for i in preconds]
    joined    = [{'pre': pre, 'post': post} for pre, post in zip(preconds, postconds)]
    testcases = dict(zip(testnames, joined))

    print json.dumps(testcases, sort_keys=True, indent=4)
