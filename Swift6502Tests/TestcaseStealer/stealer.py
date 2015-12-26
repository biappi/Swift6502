from py65.tests.devices.test_mpu6502 import MPUTests, Common6502Tests
from py65.devices.mpu6502 import MPU

import json
import itertools

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
            if value > 0xff: value = 0xff
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
            'sp': 0xff,
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

class TestHarness(MPUTests):
    def __init__  (self, *args, **kwargs): pass
    def assertTrue(self, *args, **kwargs): pass

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
        try:
            return self.mem[x]
        except:
            self.mem[x] = 0
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

def steal():
    disabled  = (
        'test_adc_bcd_off_absolute_carry_clear_in_accumulator_zeroes',
        'test_decorated_addressing_modes_are_valid',
        'test_reset_sets_registers_to_initial_states',
        'test_repr',
    )

    harness   = TestHarness()
    testnames = [i for i in dir(harness) if i.startswith('test_') and not i in disabled]
    methods   = [getattr(harness, i) for i in testnames]
    preconds  = [get_preconditions(i) for i in methods]
    postconds = [get_postconditions(i) for i in preconds]
    joined    = [{'pre': pre, 'post': post} for pre, post in zip(preconds, postconds)]
    testcases = dict(zip(testnames, joined))
    return testcases

def jsonprinter(cases):
    print json.dumps(cases, sort_keys=True, indent=4)

def s_state(d):
    print '            TestState(CpuState(A:0x%02x, X:0x%02x, Y:0x%02x, SP:0x%02x, PC:0x%04x, SR:SR(0x%02x)),' % (
        d['a'],
        d['x'],
        d['y'],
        d['sp'],
        d['pc'],
        d['p'],
    )
#
def s_mem(d, c=False):
    c = ',' if c else ''
    array = ', '.join("0x%04x:0x%02x" % i for i in d.iteritems())
    print '                      [%s])%s' % (array, c)

def swift_prologue():
    print """func SR(i: UInt8) -> CpuState.StatusRegister {
    return CpuState.StatusRegister(rawValue: i)
}

struct TestState {
    let cpu: CpuState
    let mem: [UInt16:UInt8]
    
    init (_ s : CpuState, _ m : [UInt16:UInt8]) {
        cpu = s
        mem = m
    }
}

struct TestCase {
    let name: String
    let pre:  TestState
    let post: TestState
    
    init (_ n: String, _ pr: TestState, _ po: TestState) {
        name = n
        pre  = pr
        post = po
    }
}
"""

def swiftprinter(cases):
    swift_prologue()

    print "let tests_6502 : [TestCase] = ["
    for name, case in cases.iteritems():
        print '    TestCase('
        print '        "%s",' % name
        s_state(case['pre']['regs'])
        s_mem(case['pre']['mem'], True)
        s_state(case['post']['regs'])
        s_mem(case['post']['mem'])
        print '    ),'
    print ']'

def xctestprinter(cases):
    swift_prologue()

    print "class OpcodeTests : OpcodeTestBase {"
    for name, case in cases.iteritems():
        print """
    func %s() {
        do_the_test(""" % (name)
        s_state(case['pre']['regs'])
        s_mem(case['pre']['mem'], True)
        s_state(case['post']['regs'])
        s_mem(case['post']['mem'])
        print """        )
    }"""

    print "}"

if __name__ == '__main__':
    cases = steal()
    xctestprinter(cases)
