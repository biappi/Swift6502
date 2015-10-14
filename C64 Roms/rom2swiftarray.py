import sys

def fail(string):
    print string
    sys.exit(-1)

try: romfilename = sys.argv[1]
except: fail("Usage: %s romfile romname")

try: romname = sys.argv[2]
except: fail("Usage: %s romfile romname")

rom = open(romfilename, 'rb').read()
print "let %s : [UInt8] = [" % romname
print ' ',
for i, b in enumerate(rom):
    print "0x%02X, " % ord(b),
    if (i + 1) % 16 == 0:
        print
        print ' ',
print ']'

