all: kernal.swift basic.swift character.swift

%.swift : %.rom
	python rom2swiftarray.py $< $* > $@

